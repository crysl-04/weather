import router from '@ohos.router';
@Entry
@Component
export struct PostDetail {
  //但是这样就不是持久化存储了
  @State title: string = (router.getParams() as Record<string, string>)['title'];
  @State city :string= (router.getParams() as Record<string, string>)['city'];
  @State contents:string = (router.getParams() as Record<string, string>)['contents'];
  @State picture:string=(router.getParams() as Record<string, string>)['picture'];
  build() {
    Column() {
      Row() {
        Button('<', { type: ButtonType.Capsule, stateEffect: true })
          // .fontSize('16fp')
          // .width('100%')
          //   // .height('40vp')
          // .backgroundColor('#007DFF')
          .fontSize('16fp')
          .width('50vp')
          .height('50vp')
          .alignSelf(0)
          .backgroundColor('#FF69B4')
          .fontColor('#FFFFFF')
          .borderRadius('25vp')
          .onClick(async () => {
            router.back({
              url: "pages/Index"
            })
          })
        Blank().width(20)
        Text(this.title)
          .fontSize(20)
          .margin({ bottom: 8 })

      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      Blank()
      // Text(this.contents)
      //   .fontSize(16)
      //   .fontColor(Color.Gray)
      //   .margin({ bottom: 8 })
      //   .height("100%")
      //   .margin({ bottom: 16 })
      // .width('100%')
      // Blank()
      Column(){
        Image($r(this.picture))
          .width('100%')
          .height(200)
          .margin({ right: 20 })
      }
      Scroll() {
        Column() {
          Text(this.contents)
            .fontSize(16)
            .fontColor(Color.Gray)
            .margin({ bottom: 16 })
            .width('100%')
        }
      }
      .height('100%')
      .width('100%')

    }
    // .height('100%')
    // .padding(20)
    // .borderRadius(12)
    // .backgroundColor('#FFECECEC')
    // .height(120)
    // .width('100%')
    // .justifyContent(FlexAlign.SpaceBetween)
  }
}
