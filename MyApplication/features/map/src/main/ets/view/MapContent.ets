interface KnowledgeBaseItem {
  type: string,
  title: string
}

interface Material {
  subtitle: string,
  knowledgeBase: KnowledgeBaseItem[]
}

export interface Section {
  title: string,
  brief: string,
  materials: Material[]
}

const TypeMapIcon: Record<string, string> = {
  '指南': 'app.media.ic_guide',
  '媒体': 'app.media.ic_video',
}

@Component
export struct MapContent {
  @Consume('knowledgeMapPageStack') knowledgeMapPageStack: NavPathStack;

  @Prop section: Section;
  scroller: Scroller = new Scroller();

  @Builder
  KnowledgeBlockLine(knowledgeBaseItem: KnowledgeBaseItem) {
    Row() {
      Image($r(TypeMapIcon[knowledgeBaseItem.type]))
        .width(20)
        .height(20)
      Column() {
        Text(knowledgeBaseItem.title)
          .fontFamily('HarmonyHeiTi-Medium')
          .fontSize(16)
          .fontWeight(500)
        Text(knowledgeBaseItem.type)
          .fontFamily('HarmonyHeiTi')
          .fontSize(14)
          .fontWeight(400)
      }
      .alignItems(HorizontalAlign.Start)
      .margin({ left: 18 })
      Blank()
      Image($r('app.media.ic_arrow'))
        .width(12)
        .height(24)
    }
    .width('100%')
    .height(64)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  KnowledgeBlock(material: Material) {
    Column() {
      Text(material.subtitle)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontSize(14)
        .fontWeight(500)
        .margin({ bottom: 8 })
      List({ space: 12 }) {
        ForEach(material.knowledgeBase, (item: KnowledgeBaseItem, index: number) => {
          ListItem(){
            Column() {
              // 显示知识项的标题
              this.KnowledgeBlockLine(item)


            }

          }
        }, (item: KnowledgeBaseItem, index: number) => item.title)
      }
      .backgroundColor(Color.White)
      .borderRadius(16)
      .padding({ left: 12, right: 12 })
      .divider({
        strokeWidth: 0.5,
        startMargin: 38,
        endMargin: 0,
        color: '#F2F2F2'
      })

    }
    .width('100%')
    .margin({ top: 28 })
    .alignItems(HorizontalAlign.Start)
  }


  build() {
    NavDestination() {
      Scroll(this.scroller) {
      Column() {
        Row() {
          Image($r('app.media.ic_back'))
            .width(40)
            .height(40)
            .onClick(() => {
              this.knowledgeMapPageStack.pop()
            })
          Text(this.section?.title)
            .fontFamily('HarmonyHeiTi-Bold')
            .fontSize(20)
            .fontWeight(700)
            .fontColor(Color.Black)
        }


      Text(this.section?.brief)
        .fontFamily('HarmonyHeiTi')
        .fontSize(12)
        .fontColor('rgba(0,0,0,0.60)')
        .textAlign(TextAlign.JUSTIFY)
        .fontWeight(400)
        .margin({ top: 12 })
      ForEach(this.section?.materials, (material: Material) => {
        this.KnowledgeBlock(material)
      }, (material: Material, index: number) => material.subtitle)
    }
    .padding({top: 12, left: 16, bottom: 12, right: 16})
    .alignItems(HorizontalAlign.Start)
    }
    .align(Alignment.TopStart)
    .constraintSize({ minHeight: '100%' })
    .edgeEffect(EdgeEffect.Spring)
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Auto)
    .backgroundColor('#F1F3F5')
    }
    .hideTitleBar(true)
  }
}