import { ArticleClass } from '../model/ArticleClass';
import { bufferToString } from '../util/BufferUtil';

@Component
export struct FoodCultureView{
  @State foodCultureList: Array<ArticleClass> = [];

  aboutToAppear(): void {
    this.getFoodCultureDataFromJSON()
  }

  getFoodCultureDataFromJSON() {
    getContext(this).resourceManager.getRawFileContent('FoodCultureData.json').then(value => {
      this.foodCultureList = JSON.parse(bufferToString(value)) as ArticleClass[];
    })
  }
  @Consume('articlePathStack') articlePathStack: NavPathStack;

  build() {
    Column() {
      Text('饮食文化')
        .fontColor('#182431')
        .fontSize(16)
        .fontWeight(500)
        .fontFamily('HarmonyHeiTi-medium')
        .textAlign(TextAlign.Start)
        .padding({ left: 16 })
        .margin({ bottom: 8.5 })
      List({ space: 12 }) {
        ForEach(this.foodCultureList, (item: ArticleClass) => {
          ListItem() {
            FoodCulture({ foodculture : item })
              .onClick(() => {
                this.articlePathStack.pushPathByName('articleDetail', item)
              })
          }
        }, (item: ArticleClass) => item.id)

      }
      .scrollBar(BarState.Off)
      .padding({ left: 16, right: 16 })

    }
    .margin({ top: 18 })
    .alignItems(HorizontalAlign.Start)

  }
}


@Component
struct FoodCulture {
  @Prop foodculture: ArticleClass;

  build() {
    Row() {
      Column() {
        Text(this.foodculture.title)
          .height(19)
          .width('100%')
          .fontSize(14)
          .textAlign(TextAlign.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontWeight(400)
          .margin({ top: 4 })
        Text(this.foodculture.brief)
          .height(32)
          .width('100%')
          .fontSize(12)
          .textAlign(TextAlign.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(2)
          .fontWeight(400)
          .fontColor('rgba(0, 0, 0, 0.6)')
          .margin({ top: 5 })
      }
      .height('100%')
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)
      .margin({ right: 12 })

      Image($r(this.foodculture.imageSrc))
        .objectFit(ImageFit.Cover)
        .height(64)
        .width(108)
        .borderRadius(16)
    }
    .width('100%')
    .height(88)
    .borderRadius(16)
    .backgroundColor(Color.White)
    .padding(12)
    .alignItems(VerticalAlign.Top)
  }
}

