import { promptAction, Router } from '@kit.ArkUI'
import router from '@ohos.router'

interface IUser{
  username: string,
  password: string
}
PersistentStorage.persistProp<IUser[]>('users', [])

@Entry
@Component
struct Register {
  @State username: string = ''
  @State password: string = ''
  @State err: boolean = false
  @StorageLink('users') users: IUser[] = []

  build() {
    // 根载体
    Column({ space: 10}){
      // logo载体
      Column(){
        // logo
        Row(){
          Image($r('app.media.logo'))
            .width(60)
            .height(60)
            .borderRadius(15)
            .margin({
              top: 40,
              bottom: 20
            })
        }
        // “注册界面”文字
        Row(){
          Text('登录界面')
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .margin({
              top: 20
            })
        }
        // 注册说明
        Row(){
          Text('登录以发现美好')
            .fontSize(20)
            .fontWeight(400)
            .fontColor(Color.Gray)
            .margin({
              top: 10
            })
        }
      }
      .width('100%')
      .height('30%')
      //.border({ width: 5 })
      //.borderColor(Color.Black)
      // 输入框载体
      Column(){
        // 输入框
        Column(){
          TextInput({ placeholder: '用户名'})
            .width("85%")
            .backgroundColor(Color.Transparent)
            .margin({
              top: 20
            })
            .fontSize(20)
            .onChange((usernameInput: string) =>{
              this.username = usernameInput;
            })
          Line()
            .width('85%')
            .height(1)
            .backgroundColor(Color.Gray)

          TextInput({ placeholder: '密码'})
            .width("85%")
            .backgroundColor(Color.Transparent)
            .margin({
              top: 40
            })
            .type(InputType.Password)
            .fontSize(20)
            .onChange((passwordInput: string) =>{
              this.password = passwordInput;
            })
          Line()
            .width('85%')
            .height(1)
            .backgroundColor(Color.Gray)

        }
      }
      .width('100%')
      .height('30%')
      //.border({ width: 5 })
      //.borderColor(Color.Green)
      // 按钮载体
      Column(){
        Button('登  录')
          .width('85%')
          .fontSize(20)
          .onClick(() => {
            try {
              let flag = false;
              if(this.username == null || this.password == null){
                this.err = true;
              }
              for (let i = 0; i < this.users.length; i++) {
                if(this.username == this.users[i].username && this.password == this.users[i].password){
                  flag = true;
                }
              }
              if(flag == true){
                promptAction.showToast({
                  message: '登录成功。'
                })
                router.pushUrl({
                  url: 'pages/Index',
                  params: {username: this.username}
                })
              }
              else{
                promptAction.showToast({
                  message: '用户名或密码错误，请重试。'
                })
              }
            } catch (err) {
              console.log("用户名或密码为空");
            }
          })
        // 注册按钮
        Button('注  册')
          .width('85%')
          .fontSize(20)
          .margin({
            top: 20
          })
          .fontColor(Color.White)
          .backgroundColor('#A9A9A9')
          .onClick(() => {
            if(this.username == '' || this.password == ''){
              promptAction.showToast({
                message: '用户名或密码不能为空，注册失败。'
              })
            }
            else{
              let flag = true;
              for (let i = 0; i < this.users.length; i++) {
                if(this.username == this.users[i].username){
                  flag = false;
                }
              }
              if(flag == true){
                this.users[this.users.length] = {
                  username: this.username,
                  password: this.password
                }
                promptAction.showToast({
                  message: '注册成功，享受你的旅程吧！'
                })
              }
              else{
                promptAction.showToast({
                  message: '用户名重复，注册失败。'
                })
              }
            }
          })
      }
      .width('100%')
      .height('20%')
      //.border({ width: 5 })
      //.borderColor('#D3D3D3')
      Column(){
        Text('关于我们')
          .fontColor('#007DFF')
          .onClick(() => {
            promptAction.showToast({message: 'this.username \nthis.password'})
          })
        Text('天气，资讯一站式查询平台')
          .fontSize(20)
          .fontWeight(400)
          .margin({
            top: 10
          })
      }
      .width('100%')
      .height('10%')
      //.border({ width: 5 })
      //.borderColor(Color.Grey)
    }
    .width('100%')
    .height('100%')
    //.border({ width: 7 })
    //.borderColor(Color.Red)
  }
}