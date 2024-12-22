import UsersTable from '../common/database/tables/UserTable'
import UsersData from '../viewmodel/UsersData'
import { relationalStore } from '@kit.ArkData'


interface NodeItem {
  id: number;
  city: string;
  weather: string;
  temperature: number;
  winddirection: string;
  windpower: string;
  humidity: number;
  reporttime: string;
}


@Entry
@Component
export struct My {
  tableName :string = 'WeatherRecords'
  store: relationalStore.RdbStore | null = null

  // private usersTable: UsersTable = new UsersTable(); // 初始化用户表
  // private username: string = '';
  // private email: string = '';
  // private password: string = '';
  async getStoreInstance() {
    // 如果已经存在，直接返回
    if (this.store) {
      return this.store
    }
    // 获取操作数据库的管理对象(如果数据库文件不存在，会自动创建数据库文件)
    this.store = await relationalStore.getRdbStore(getContext(), {
      name: 'RdbTest.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1, // 数据库安全级别
    })
    // 返回 store 对象
    return this.store
  };

  async queryWeatherRecords() {
  // 获取操作数据库的对象
  const store = await this.getStoreInstance()
  // 谓词（条件）
  const predicates = new relationalStore.RdbPredicates("WeatherRecords")
  predicates.orderByDesc("id") // 按 `id` 倒序排列

  // resultSet 结果集
  const resultSet = await store.query(predicates)
  // 准备一个数组，用于存储数据库提取的数据
  const list: NodeItem[] = []

  // resultSet.goToNextRow()   指针移动到下一行
  while (resultSet.goToNextRow()) {
    // 按列下标提取数据
    list.push({
      id: resultSet.getLong(resultSet.getColumnIndex('id')),
      city: resultSet.getString(resultSet.getColumnIndex('city')),
      weather: resultSet.getString(resultSet.getColumnIndex('weather')),
      temperature: resultSet.getDouble(resultSet.getColumnIndex('temperature')),
      winddirection: resultSet.getString(resultSet.getColumnIndex('winddirection')),
      windpower: resultSet.getString(resultSet.getColumnIndex('windpower')),
      humidity: resultSet.getDouble(resultSet.getColumnIndex('humidity')),
      reporttime: resultSet.getString(resultSet.getColumnIndex('reporttime'))
    })
  }

  // 显示结果
  AlertDialog.show({ message: JSON.stringify(list, null, 2) })
}



  aboutToAppear(): void {
    this.queryWeatherRecords()

  }

  build() {
    Button('查询天气记录')
      .onClick(async () => {
        // 获取操作数据库的对象
        const store = await this.getStoreInstance();
        // 谓词（条件）
        const predicates = new relationalStore.RdbPredicates("WeatherRecords");
        predicates.orderByDesc("id"); // 按 `id` 倒序排列

        // resultSet 结果集
        const resultSet = await store.query(predicates);
        // 准备一个数组，用于存储数据库提取的数据
        const list: NodeItem[] = [];

        // resultSet.goToNextRow()   指针移动到下一行
        while (resultSet.goToNextRow()) {
          // 按列下标提取数据
          list.push({
            id: resultSet.getLong(resultSet.getColumnIndex('id')),
            city: resultSet.getString(resultSet.getColumnIndex('city')),
            weather: resultSet.getString(resultSet.getColumnIndex('weather')),
            temperature: resultSet.getDouble(resultSet.getColumnIndex('temperature')),
            winddirection: resultSet.getString(resultSet.getColumnIndex('winddirection')),
            windpower: resultSet.getString(resultSet.getColumnIndex('windpower')),
            humidity: resultSet.getDouble(resultSet.getColumnIndex('humidity')),
            reporttime: resultSet.getString(resultSet.getColumnIndex('reporttime'))
          });
        }

        // 显示结果
        AlertDialog.show({ message: JSON.stringify(list, null, 2) });
      });


  }

    // Scroll() {
    //   Column() {
    //     // 用户名输入框
    //     TextInput({ placeholder: '输入用户名' })
    //       .onChange((value: string) => {
    //         this.username = value;
    //       })
    //       .margin({ top: 20 });
    //
    //     // 邮箱输入框
    //     TextInput({ placeholder: '输入邮箱'})
    //       .onChange((value: string) => {
    //         this.email = value;
    //       })
    //       .margin({ top: 20 });
    //
    //
    //     // 注册按钮
    //     Button('注册')
    //       .width(150)
    //       .margin({ top: 20 })
    //       .onClick(() => this.registerUser());
    //
    //     // 登录按钮
    //     Button('登录')
    //       .width(150)
    //       .margin({ top: 20 })
    //       .onClick(() => this.loginUser());
    //   }.padding(20)
    // }
    // .height('100%')
    // .width('100%');


  // // 注册用户的方法
  // private registerUser() {
  //   this.usersTable.insertData(this.username, this.email, (success: boolean) => {
  //     if (success) {
  //       console.log('注册成功！');
  //     } else {
  //       console.log('注册失败！');
  //     }
  //   });
  // }
  //
  // // 登录用户的方法
  // private loginUser() {
  //   this.usersTable.loginUser(this.username, this.email, (success: boolean, userData: UsersData | null) => {
  //     if (success) {
  //       console.log('登录成功！', userData);
  //     } else {
  //       console.log('登录失败！用户名或邮箱无效。');
  //     }
  //   });
  // }
}
