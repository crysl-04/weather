import { NavBarItem, NavBarItemType } from '../view/NavBarItem';
import { Section, MapContent } from '../view/MapContent';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct Map {
  @State navBarList: NavBarItemType[] = [
    { order: '01', title: '北京市' },
    { order: '02', title: '广州市' },
    { order: '03', title: '苏州市' },

  ];
  @Provide('knowledgeMapPageStack') knowledgeMapPageStack: NavPathStack = new NavPathStack();
  @State currentNavBarIndex: number = -1;
  @State sections: Section[] = [];
  private getSections() {
    try {
      getContext(this).resourceManager.getRawFileContent("MapData1.json", (error: BusinessError, value: Uint8Array) => {
        const textDecoder = util.TextDecoder.create("utf-8");
        const res = textDecoder.decodeWithStream(value, { stream: false });
        this.sections = JSON.parse(res);
      });
    } catch (error) {
      console.error(`callback getRawFileContent failed, error is ${JSON.stringify(error)}`)
    }
  }


  aboutToAppear(): void {
    this.getSections();
  }

  @Builder
  PageMap(name: string) {
    if (name === 'MapContent') {
      MapContent({ section: this.sections[this.currentNavBarIndex] });
    }

  }

  build() {
    Navigation(this.knowledgeMapPageStack) {
      Scroll() {
      Column() {
      Text('历史文化')
        .fontFamily('HarmonyHeiTi-Bold')
        .fontSize(24)
        .fontColor(Color.Black)
        .textAlign(TextAlign.Start)
        .lineHeight(33)
        .fontWeight(700)
        .width('100%')
      Image($r('app.media.map_banner'))
        .width('100%')
        .borderRadius(16)
        .margin({ top: 19, bottom: 8 })
      Text('习近平总书记强调：“一个城市的历史遗迹、文化古迹、人文底蕴，是城市生命的一部分。”历史文化以各种方式保留在城市肌体里，沉淀为独特的记忆和标识。以真实的历史文化遗产为载体，城市的文脉才能得到有效传承。')
        .fontFamily('HarmonyHeiTi')
        .fontSize(14)
        .fontColor('rgba(0,0,0,0.60)')
        .fontWeight(400)
        .textAlign(TextAlign.Start)
      List({ space: 12 }) {
        ForEach(this.navBarList, (item: NavBarItemType, index: number) => {
          ListItem() {
            NavBarItem({ navBarItem: item, currentNavBarIndex: this.currentNavBarIndex })
          }
          .width('100%')
        }, (item: NavBarItemType): string => item.title)
      }
      .width('100%')
      .margin({ top: 24 })

    }
    .padding({ top: 12, right: 16, bottom: 12, left: 16})
    }
    .backgroundColor('#F1F3F5')
    .align(Alignment.TopStart)
    .constraintSize({ minHeight: '100%' })
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.Auto)
    .scrollBarColor(Color.Gray)
    .edgeEffect(EdgeEffect.Spring)
    }
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .navDestination(this.PageMap)
    .navBarWidth(288)

  }
}