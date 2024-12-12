import { relationalStore, ValuesBucket } from '@kit.ArkData'

// ValuesBucket 数据库支持的类型
interface NoteItem extends ValuesBucket {
  id: number | null // 新增时设置 id 为空值 null，用于自增 id
  title: string
  content: string
  date_added: number
}
@Entry
@Component
struct RdbStoreTestPage {
  // 表名
  tableName: string = 'privacy_note'
  // SQL 语法：（SQL语法的数据类型关键词不一样，可通过AI生成SQL语句）
  // 解释说明：
  //   CREATE TABLE IF NOT EXISTS     如果表不存在才创建新的表
  //   INTEGER -> number              INTEGER 整数型   FLOAT 浮点数
  //   PRIMARY KEY                    主键(唯一标识)
  //   AUTOINCREMENT                  自增
  //   TEXT -> string                 字符串型
  //   NOT NULL                       不允许空
  sqlCreate: string = `CREATE TABLE IF NOT EXISTS ${this.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        content TEXT NOT NULL,
        date_added INTEGER NOT NULL
      )`
  // 操作数据库的管理对象
  store: relationalStore.RdbStore | null = null

  // 获取数据库管理对象
  async getStoreInstance() {
    // 如果已经存在，直接返回
    if (this.store) {
      return this.store
    }
    // 获取操作数据库的管理对象(如果数据库文件不存在，会自动创建数据库文件)
    this.store = await relationalStore.getRdbStore(getContext(), {
      name: 'rdb.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1, // 数据库安全级别
    })
    // 执行创建表的语句 execute 执行
    this.store.executeSql(this.sqlCreate)
    // 返回 store 对象
    return this.store
  }

  build() {
    Navigation() {
      Scroll() {
        Column({ space: 10 }) {
          Button('创建数据库文件')
            .onClick(async () => {
              // 获取操作数据库的管理对象(如果数据库文件不存在，会自动创建数据库文件)
              const store = await relationalStore.getRdbStore(getContext(), {
                name: 'RDB.db', // 数据库文件名
                securityLevel: relationalStore.SecurityLevel.S1, // 数据库安全级别
              })
              // 执行创建表的语句 execute 执行
              store.executeSql(this.sqlCreate)
              AlertDialog.show({ message: '创建成功' })
            })
          Button('查询数据库表的字段')
            .onClick(async () => {
              // 获取操作数据库的对象
              const store = await this.getStoreInstance()
              // 谓词(条件)，谓词类需要 new 实例化，传入表名 privacy_note
              const predicates = new relationalStore.RdbPredicates(this.tableName)
              // query 查询，传入必传参数 谓词
              const resultSet = await store.query(predicates)
              AlertDialog.show({ message: '数据库的字段名：' + resultSet.columnNames })
            })
          Button('新建一条数据')
            .onClick(async () => {
              // 获取操作数据库的对象
              const store = await this.getStoreInstance()
              // 添加一条数据
              const id = await store.insert(this.tableName, {
                id: null, // 新增时设置 id 为空值 null，用于自增 id
                title: '哈哈哈呵呵呵',
                content: '111',
                date_added: Date.now()
              } as NoteItem)
              AlertDialog.show({ message: '新增数组成功，数据的id为：' + id })
              // 批量添加，传入数组
              // store.batchInsert(表名, 数组)
            })
          Button('查询所有数据')
            .onClick(async () => {
              // 获取操作数据库的对象
              const store = await this.getStoreInstance()
              // 谓词（条件）
              const predicates = new relationalStore.RdbPredicates(this.tableName)
              predicates.orderByDesc('id') // 倒序(由大到小，常用于排序)
              // predicates.orderByAsc('id')   // 正序(小到大，常用于排序)
              // predicates.equalTo('id', 1)    // 等于(常用于详情页)
              // predicates.in('id', [1, 3, 5]) // 查找多项(常用批量删除)
              // predicates.like('title', '%哈%') //  模糊匹配(常用于搜索)
              // 还有很多...
              // predicates.greaterThan('id', 3)
              // resultSet 结果集
              const resultSet = await store.query(predicates)
              // 准备一个数组，用于存储数据库提取的数据
              const list: NoteItem [] = []
              // resultSet.goToNextRow()   指针移动到下一行
              while (resultSet.goToNextRow()) {
                // 移动指针的时候提取数据，按列下标提取数据
                list.push({
                  // resultSet.getColumnIndex()        根据列名称获取下标(索引)
                  id: resultSet.getLong(resultSet.getColumnIndex('id')),
                  title: resultSet.getString(resultSet.getColumnIndex('title')),
                  content: resultSet.getString(resultSet.getColumnIndex('content')),
                  date_added: resultSet.getLong(resultSet.getColumnIndex('date_added')),
                })
              }
              // 循环结束后，获取所有数据
              AlertDialog.show({ message: JSON.stringify(list, null, 2) })
            })

          Button('查询数据总条数')
            .onClick(async () => {
              // 获取操作数据库对象
              const store = await this.getStoreInstance()
              // 谓词(条件)
              const predicates = new relationalStore.RdbPredicates(this.tableName)
              // 结果集
              const resultSet = await store.query(predicates)
              AlertDialog.show({ message: '数据总条(行)数 rowCount：' + resultSet.rowCount })
            })

          Button('删除数据')
            .onClick(async () => {
              // 获取操作数据库对象
              const store = await this.getStoreInstance()
              const predicates = new relationalStore.RdbPredicates(this.tableName)
              // 注意!!!：记得添加 predicates 限定条件，否者会删除所有数据
              // predicates.equalTo('id', 2)        // equalTo 删除一条
              predicates.in('id', [1, 2, 3, 4, 5]) //  in      批量删除
              const affectedRows = await store.delete(predicates)
              AlertDialog.show({ message: '受影响行数：' + affectedRows })
            })

          Button('更新(修改)数据')
            .onClick(async () => {
              // 获取操作数据库对象
              const store = await this.getStoreInstance()
              // 谓词(条件)
              const predicates = new relationalStore.RdbPredicates(this.tableName)
              // 注意!!!：记得添加 predicates 限定条件，否者修改全部
              predicates.equalTo('id', 10)
              // 待更新数据
              const value = {
                title: '新的标题',
                content: '新的内容'
              } as NoteItem
              const affectedRows = await store.update(value, predicates)
              AlertDialog.show({ message: '更新(修改)数据 - 受影响行数：' + affectedRows })
            })
          // Button('删除数据库文件')
          //   .enabled(false)
          //   .onClick(async () => {
          //     try {
          //       await relationalStore.deleteRdbStore(getContext(), 'heima.db')
          //       AlertDialog.show({ message: '删除成功' })
          //     } catch (error) {
          //       AlertDialog.show({ message: JSON.stringify(error, null, 2) })
          //     }
          //   })
        }
        .constraintSize({ minHeight: '100%' })
      }
      .width('100%')
      .height('100%')
    }
    .title('关系型数据库')
    .titleMode(NavigationTitleMode.Mini)
  }
}