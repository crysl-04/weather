import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { relationalStore, ValuesBucket } from '@kit.ArkData'
import {myPost} from '../myInterface/postInterface';
@Entry
@Component
  //添加帖子的页面
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
      Column(){

       //提示输入帖子的标题、地点和内容

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
           //点击按钮，保存帖子

            if(this.rdb==null){
              this.rdb = await relationalStore.getRdbStore(getContext(),{
                name: 'RdbTest.db',
                securityLevel:relationalStore.SecurityLevel.S1
              });
            }

            //没有表就创建表
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

            //查询得到表中已经存放的所有数据，将这些数据都存储在postList中

            let predicates= new relationalStore.RdbPredicates('postsTable')
            predicates.orderByDesc('id')

            let resultSet = await this.rdb.query(predicates)
            while (resultSet.goToNextRow()) {

              let row = resultSet.getRow() as myPost

              this.postList.push(row)
            }
            //回到原来的页面，将postList穿回，得到动态创建的帖子的数据
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
