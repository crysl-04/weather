import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { relationalStore, ValuesBucket } from '@kit.ArkData'
import {myPost} from '../myInterface/postInterface';
@Entry
@Component
  //完成添加帖子的页面
struct AddPost {
  @State title:string=''
  @State city:string=''
  @State contents:string=''
  @State rdb: relationalStore.RdbStore | null = null;
  @State post:myPost={
    id:0,
    title:'',
    city:'',
    contents:''

  }
  @State postList:myPost[]=[]
  build() {
    Column() {
      Row() {
        Text('')
          .id('AddPostHelloWorld')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Blank()
        Text('')
          .id('AddPostHelloWorld')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
      }
      .height('10%')
      .width('90%')
      //请输入帖子标题
      //请输入帖子相关地点
      Column(){
        //如何得到输入内容
        //然后再存储起来
        Text('标题:')
        TextInput({ placeholder: '请输入帖子标题' })
          .onChange((value) => {
            this.title = value;
          });
        Text('地点:')
        TextInput({ placeholder: '请输入帖子相关地点' })
          .onChange((value) => {
            this.city = value;
          });
        Text('内容:')
        TextInput({ placeholder: '请输入帖子内容' })
          .onChange((value) => {
            this.contents = value;
          });
        Button('保存')
          .fontSize('16fp')
          .width('296vp')
          .height('40vp')
          .backgroundColor('#007DFF')
          .onClick(async () => {
            //能否正常进行数据的传递呢，看看这种方法究竟能不能行
            // promptAction.showToast({
            //   message: `title:${this.title}\n`+
            //     `city: ${this.city}\n`+
            //     `contents: ${this.contents}\n`
            //
            // });
            //存储到数据库中
            if(this.rdb==null){
              this.rdb = await relationalStore.getRdbStore(getContext(),{
                name: 'RdbTest.db',
                securityLevel:relationalStore.SecurityLevel.S1
              });
            }

            //如果不存在创建表postsTable,没有出现每次都重新创建表的情况，但是每次重新开启数据库表中的内容就会清空
            //似乎并没有持久化，怎样做呢
            let createSQL:string =
              `CREATE TABLE IF NOT EXISTS postsTable
              (id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              city  TEXT NOT NULL,
             contents TEXT NOT NULL

           )`;
            try {
              await this.rdb.executeSql(createSQL);
              promptAction.showToast({ message: `Database and table created successfully.\n` });
            } catch (error) {
              let errorMessage:string = error.message || "Unknown error";
              let errorStack:string = error.stack || "No stack trace available";
              promptAction.showToast({
                message: `Error creating table:\nMessage: ${errorMessage}\nStack: ${errorStack}`,
                duration: 5000,  // 持续时间5秒
                bottom: 200      // 显示在屏幕底部
              });
            }
            // 插入数据
            try {
              await this.rdb.insert('postsTable', {
                id: null, // 新增时设置 id 为空值 null，用于自增 id 这对吗
                title: this.title,
                city: this.city,
                contents: this.contents
              } )
              promptAction.showToast({ message: `Insert post successfully.\n` });
            }
            catch (error) {
              let errorMessage:string = error.message || "Unknown error";
              let errorStack:string = error.stack || "No stack trace available";
              promptAction.showToast({
                message: `Error inserting data:\nMessage: ${errorMessage}\nStack: ${errorStack}`,
                duration: 5000,
                bottom: 200
              });
            }
            //查询得到表中数据
            let predicates= new relationalStore.RdbPredicates('postsTable')
            predicates.orderByDesc('id')

            let resultSet = await this.rdb.query(predicates)
            while (resultSet.goToNextRow()) {
              // 获取行数据
              let row = resultSet.getRow() as myPost
              // 追加到数组中
              this.postList.push(row)
            }
            router.back({
              url: "pages/Index",
              params: {
                postList:this.postList
              }
            })
          })
      }
      .height("100%")
      .width('90%')
    }
    .height('100%')
    .width('100%')
  }
}
