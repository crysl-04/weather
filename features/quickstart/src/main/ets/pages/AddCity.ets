import router from '@ohos.router';
@Component
export struct AddCity {
  @State message: string = 'Hello World';

  @State cityCodeList : number[]=[]
  @State cityNameList : string[]=[]



  build() {
    NavDestination(){

      Row() {
        Column() {
          Text(this.message)

            .fontSize(50)
            .fontWeight(FontWeight.Bold)
        }
        .width('100%')
      }
      .height('100%')
    }
  }






}
