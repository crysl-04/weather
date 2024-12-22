import {ArticleClass } from '../model/ArticleClass'
import { bufferToString } from '../util/BufferUtil';

@Component
export struct InstrumentView{
  @State instrumentList: Array<ArticleClass> = [];

  aboutToAppear(): void {
    this.getInstrumentDataFromJSON()
  }

  getInstrumentDataFromJSON() {
    getContext(this).resourceManager.getRawFileContent('InstrumentData.json').then(value => {
      this.instrumentList = JSON.parse(bufferToString(value)) as ArticleClass[];
    })
  }

  @Consume('articlePathStack') articlePathStack: NavPathStack;

  build() {
    Column() {
      Text('风景名胜')
        .fontColor('#182431')
        .fontSize(16)
        .fontWeight(500)
        .fontFamily('HarmonyHeiTi-medium')
        .textAlign(TextAlign.Start)
        .padding({ left: 16 })
        .margin({ bottom: 8.5 })
      Grid() {
        ForEach(this.instrumentList, (item: ArticleClass) => {
          GridItem() {
            Instrument({ instrument: item })
              .onClick(() => {
                this.articlePathStack.pushPathByName('articleDetail', item)
              })
          }
        }, (item: ArticleClass) => item.id)

      }
      .rowsTemplate('1fr')
      .columnsGap(8)
      .scrollBar(BarState.Off)
      .height(169)
      .padding({ top: 2, left: 16, right: 16 })
    }
    .margin({ top: 18 })
    .alignItems(HorizontalAlign.Start)

  }
}

@Component
struct Instrument {
  @Prop instrument: ArticleClass;

  build() {
    Column() {
      Image($r(this.instrument.imageSrc))
        .width('100%')
        .objectFit(ImageFit.Cover)
        .height(96)
        .borderRadius({
          topLeft: 16,
          topRight: 16
        })
      Text(this.instrument.title)
        .height(19)
        .width('100%')
        .fontSize(14)
        .textAlign(TextAlign.Start)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .fontWeight(400)
        .padding({ left: 12, right: 12 })
        .margin({ top: 8 })
      Text(this.instrument.brief)
        .height(32)
        .width('100%')
        .fontSize(12)
        .textAlign(TextAlign.Start)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(2)
        .fontWeight(400)
        .fontColor('rgba(0, 0, 0, 0.6)')
        .padding({ left: 12, right: 12 })
        .margin({ top: 2 })
    }
    .width(160)
    .height(169)
    .borderRadius(16)
    .backgroundColor(Color.White)
  }
}
