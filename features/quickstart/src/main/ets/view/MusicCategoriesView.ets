import { ArticleClass } from '../model/ArticleClass';
import { bufferToString } from '../util/BufferUtil';

@Component
export struct MusicCategoriesView{
  @State musicCategoriesList: Array<ArticleClass> = [];

  aboutToAppear(): void {
    this.getMusicCategoriesDataFromJSON()
  }

  getMusicCategoriesDataFromJSON() {
    getContext(this).resourceManager.getRawFileContent('MusicCategoriesData.json').then(value => {
      this.musicCategoriesList = JSON.parse(bufferToString(value)) as ArticleClass[];
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
        ForEach(this.musicCategoriesList, (item: ArticleClass) => {
          ListItem() {
            MusicCategories({ musicCategories: item })
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
struct MusicCategories {
  @Prop musicCategories: ArticleClass;

  build() {
    Row() {
      Column() {
        Text(this.musicCategories.title)
          .height(19)
          .width('100%')
          .fontSize(14)
          .textAlign(TextAlign.Start)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .fontWeight(400)
          .margin({ top: 4 })
        Text(this.musicCategories.brief)
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

      Image($r(this.musicCategories.imageSrc))
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

