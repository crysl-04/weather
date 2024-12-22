import { QuickStartPage } from '@ohos/quickstart';
import {myPost} from '../myInterface/postInterface';
import { Map } from '@ohos/map';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
import { relationalStore, ValuesBucket } from '@kit.ArkData'
import { My } from '@ohos/learning';

@Entry
@Component
struct Index {
  @State postBase1:myPost[]=[
    {id:0,title:"上海|熬夜准备的攻略", city:'上海',
      contents:"一、必游景点\n" +
        "            外滩与浦东陆家嘴\n" +
        "            外滩：欣赏沿黄浦江的历史建筑群，夜晚霓虹灯点亮的景色尤为震撼。\n" +
        "            陆家嘴：登上上海中心大厦或东方明珠塔，俯瞰整个城市。\n" +
        "            南京路步行街\n" +
        "            上海最繁忙的商业街，购物、美食、老字号餐馆都应有尽有。\n" +
        "            豫园与城隍庙\n" +
        "            豫园：典型的江南古典园林，适合感受传统文化。\n" +
        "            城隍庙：尝遍各式上海特色小吃，如小笼包、生煎馒头等。\n" +
        "            田子坊\n" +
        "            创意街区，集艺术、小资和老弄堂文化于一体，适合拍照打卡。\n" +
        "            朱家角古镇\n" +
        "            位于上海郊区，保留了水乡特色，是体验慢生活的好去处。\n" +
        "            上海迪士尼乐园\n" +
        "            老少皆宜的娱乐项目，不容错过的精彩演出与烟花秀。\n" +
        "            上生·新所\n" +
        "            工业风与现代设计结合的文创园，适合拍照和享受咖啡时光。\n" +
        "            二、美食推荐\n" +
        "            本帮菜\n" +
        "            必试菜肴：红烧肉、油爆虾、熏鱼。\n" +
        "            推荐餐厅：老正兴菜馆、新荣记（高级版本）、绿波廊。\n" +
        "            街头小吃\n" +
        "            南翔小笼：推荐城隍庙的南翔馒头店。\n" +
        "            生煎：推荐小杨生煎或阿大葱油饼。\n" +
        "            国际美食\n" +
        "            法式大餐：外滩的 M on the Bund。\n" +
        "            日料：陆家嘴的喜多川或鮨一。\n" +
        "            三、住宿推荐\n" +
        "            外滩区域\n" +
        "            和平饭店：历史悠久的奢华酒店，地理位置优越。\n" +
        "            华尔道夫酒店：现代化设施与历史风情相结合。\n" +
        "            静安寺区域\n" +
        "            适合购物与美食，推荐静安香格里拉或锦江都城。\n" +
        "            徐汇与衡山路区域\n" +
        "            环境幽静，适合喜欢文艺气息的游客。\n" +
        "            经济型选择\n" +
        "            青旅如上海蓝山青年旅舍、Mingtown国际青年旅舍."}]
  @State postBase2:myPost[]=[{id:0,title:"黑龙江|写了三天的攻略", city:'黑龙江',
    contents:'一、必游景点\n' +
      '哈尔滨市\n' +
      '\n' +
      '中央大街：感受浓郁的欧陆风情，欣赏百年建筑，品尝马迭尔冰棍。\n' +
      '圣索菲亚大教堂：东正教风格建筑，现为哈尔滨建筑艺术馆。\n' +
      '冰雪大世界（冬季）：世界级冰雪主题乐园，夜晚的灯光秀震撼人心。\n' +
      '太阳岛公园：夏季适合避暑游玩，冬季有雪雕艺术展。\n' +
      '雪乡（中国雪乡）\n' +
      '\n' +
      '位于牡丹江市双峰林场，以梦幻般的雪蘑菇屋和浓厚的东北民俗文化闻名，冬季摄影天堂。\n' +
      '漠河北极村\n' +
      '\n' +
      '中国最北的村庄，可体验极夜、北极光和白昼现象。\n' +
      '北极村地标：北极点村标、“神州北极”碑。\n' +
      '五大连池风景区\n' +
      '\n' +
      '世界地质公园，由火山堰塞湖组成，可泡矿泉水温泉，观赏火山奇观。\n' +
      '镜泊湖\n' +
      '\n' +
      '中国最大的高山堰塞湖，四季皆宜，夏季可坐游船，冬季可观冰瀑。\n' +
      '扎龙湿地\n' +
      '\n' +
      '中国丹顶鹤栖息地，夏秋季节可观赏成群鹤舞的壮丽景观。\n' +
      '伊春林都\n' +
      '\n' +
      '被誉为“中国林都”，夏秋季节林海景色壮丽无比，适合徒步和森林浴。\n' +
      '二、美食推荐\n' +
      '东北菜\n' +
      '\n' +
      '锅包肉：黑龙江特色，甜酸口感，推荐老厨家或大江南。\n' +
      '小鸡炖蘑菇：经典东北菜，用山珍蘑菇炖鸡，风味浓郁。\n' +
      '杀猪菜：传统农家菜，包含酸菜、血肠、肉片等。\n' +
      '地方特色小吃\n' +
      '\n' +
      '哈尔滨红肠：肉质紧实，烟熏风味浓郁。\n' +
      '黏豆包：东北特产，用黏米做皮，内夹豆沙。\n' +
      '铁锅炖：大铁锅炖鱼、炖排骨等，风味独特。\n' +
      '俄罗斯风味美食\n' +
      '\n' +
      '格瓦斯：俄罗斯传统饮品。\n' +
      '大列巴：俄式面包，口感扎实，适合搭配黄油或果酱。\n' +
      '三、住宿推荐\n' +
      '哈尔滨\n' +
      '\n' +
      '豪华型：哈尔滨香格里拉大酒店、万达文华酒店。\n' +
      '中档型：中央大街附近的国际连锁酒店。\n' +
      '特色民宿：中央大街周边的俄式风情民宿。\n' +
      '雪乡\n' +
      '\n' +
      '农家院住宿：感受东北火炕，体验最地道的东北民俗。\n' +
      '漠河北极村\n' +
      '\n' +
      '北极村民宿：温馨舒适，可体验极地的寒冷。\n' +
      '五大连池\n' +
      '\n' +
      '矿泉温泉酒店：泡温泉、住酒店两不误。'}]
  @State postList:myPost[]=[]
  //   {
  //   title:'',
  //   author:'',
  //   position:'',
  //   contents:''
  // }
  // @State title:string=''
  // @State city:string=''
  // @State contents:string=''

  onPageShow(){
    //每次进入这个页面都要执行
    if(router.getParams()){

      this.postList=(router.getParams() as Record<string, myPost[]>)['postList'];
      //到底选择存数据库还是接口列表呢  数据库吧
      // //试试接口
      // this.post.title=this.title
      // this.post.position=this.city
      // this.post.contents=this.contents
      // this.postList.push(this.post)
      promptAction.showToast({
        message: `we get the post\n`
      });
    }

  }
  @State currentIndex: number = 0;
  private tabsController : TabsController = new TabsController();

  @Builder
  tabBarBuilder(title: string, targetIndex: number, selectedIcon: Resource, unselectIcon: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedIcon : unselectIcon)
        .width(24)
        .height(24)
      Text(title)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontSize(10)
        .fontColor(this.currentIndex === targetIndex ? '#0A59F7' : 'rgba(0,0,0,0.60)')
        .textAlign(TextAlign.Center)
        .lineHeight(14)
        .fontWeight(500)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(targetIndex);
    })
  }

  build()
  {

    Tabs({ barPosition: BarPosition.End, controller: this.tabsController }) {
      TabContent() {

        QuickStartPage()
      }
      .tabBar(this.tabBarBuilder('首页', 0, $r('app.media.ic_01_on'), $r('app.media.ic_01_off')))

      TabContent() {

        share({postList:this.postList,postBase1:this.postBase1,postBase2:this.postBase2})
      }
      .tabBar(this.tabBarBuilder('分享', 1, $r('app.media.ic_01_on'), $r('app.media.ic_01_off')))

      // TabContent() {
      //   Map()
      // }
      // .tabBar(this.tabBarBuilder('历史文化', 2, $r('app.media.ic_01_on'), $r('app.media.ic_01_off')))

      // TabContent() {
      //   My()
      // }
      // .tabBar(this.tabBarBuilder('我的', 2, $r('app.media.ic_01_on'), $r('app.media.ic_01_off')))

    }
    .scrollable(false)
    .vertical(false)
    .divider({
      strokeWidth:0.5,
      color:'#0D182431'
    })
    .backgroundColor('#F1F3F5')
    .padding({top:36,bottom:28})

  }
}
@Component
struct share{
  @Link  postList:myPost[]
  @Link postBase1:myPost[]
  @Link postBase2:myPost[]
  // @State post:myPost={
  //   title:'',
  //   author:'',
  //   position:'',
  //   contents:''
  //
  // }
  // @State title:string=''
  // @State city:string=''
  // @State contents:string=''
  // onPageShow(){
  //   if(router.getParams()){
  //
  //     this.title = (router.getParams() as Record<string, string>)['title'];
  //     this.city = (router.getParams() as Record<string, string>)['city'];
  //     this.contents = (router.getParams() as Record<string, string>)['city'];
  //     this.post.title=this.title
  //     this.post.position=this.city
  //     this.post.contents=this.contents
  //     this.postList.push(this.post)
  //     promptAction.showToast({
  //       message: `we get the post\n`
  //     });
  //   }
  //
  // }
  build(){
    Column(){
      Row(){
        Text('旅游分享')
          .id('travelShare')
          .fontSize(24)
          .fontWeight('700')
          .width('50%')
          .textAlign(TextAlign.Start)
          .padding({ left: 16 })
          .fontFamily('HarmonyHeiTi-Bold')
          .lineHeight(33)
        Blank()
        Button('+', { type: ButtonType.Capsule, stateEffect: true })
          // .fontSize('16fp')
          // .width('100%')
          //   // .height('40vp')
          // .backgroundColor('#007DFF')
          .fontSize('16fp')
          .width('50vp')
          .height('50vp')
          .backgroundColor('#FF69B4')
          .fontColor('#FFFFFF')
          .borderRadius('25vp')
          .onClick(async () => {
            promptAction.showToast({
              message: `click the button\n`
            });
            router.pushUrl({
              url: "pages/addPost"
            }).catch((error: Error) => {
              promptAction.showToast({
                message: `cannot change the page: ${error.message}\n`
              });
            });
          })

        //进入另外一个页面
        // title:string;
        // author:string;
        // position:string;
        // contents:string;

      }
      //原本就有的帖子：
      List(){
        ForEach(this.postBase1,(item:myPost,index:number)=>{
          ListItem(){
            Row(){
              onePost({ item: item,PictureSource:'app.media.shanghai' })
                .margin({ top: 10 })
              // Text(item.title)
              // Blank()
              // Text(item.city)
            }

            .height('20%')
            .width('100%')
          }
          .padding(5)  // 添加内边距
          .onClick(() => {
            //点击查看post具体内容

            router.pushUrl({
              url: "pages/postDetail",
              params: {
                picture:'app.media.shanghai',
                id:item.id,
                title:item.title,
                city:item.city,
                contents:item.contents
              }
            })
          })
        })
      }
      List(){
        ForEach(this.postBase2,(item:myPost,index:number)=>{
          ListItem(){
            Row(){
              onePost({ item: item,PictureSource:'app.media.heilongjiang' })
                .margin({ top: 10 })
              // Text(item.title)
              // Blank()
              // Text(item.city)
            }

            .height('20%')
            .width('100%')
          }
          .padding(5)  // 添加内边距
          .onClick(() => {
            //点击查看post具体内容

            router.pushUrl({
              url: "pages/postDetail",
              params: {
                picture:'app.media.heilongjiang',
                id:item.id,
                title:item.title,
                city:item.city,
                contents:item.contents
              }
            })
          })
        })
      }
      //展示帖子
      //遍历所有存储的列表中的项
      List(){
        ForEach(this.postList,(item:myPost,index:number)=>{
          ListItem(){
            Row(){
              onePost({ item: item,PictureSource:'app.media.Mypicture' })
                .margin({ top: 10 })
              // Text(item.title)
              // Blank()
              // Text(item.city)
            }

            .height('20%')
            .width('100%')
          }
          .padding(5)  // 添加内边距
          .onClick(() => {
            //点击查看post具体内容

            router.pushUrl({
              url: "pages/postDetail",
              params: {
                picture:'app.media.Mypicture',
                id:item.id,
                title:item.title,
                city:item.city,
                contents:item.contents
              }
            })
          })
        })
      }

    }
  }
}
@Component
struct onePost{
  @Prop item:myPost
  @Prop PictureSource:string
  build() {
    Row() {
      Image($r(this.PictureSource))
        .width(80)
        .height(80)
        .margin({ right: 20 })

      Column() {
        Text(this.item.title)
          .fontSize(20)
          .margin({ bottom: 8 })
        Blank()
        Text(this.item.city)
          .fontSize(16)
          .fontColor(Color.Gray)
          .margin({ bottom: 8 })
      }
      .alignItems(HorizontalAlign.Start)
      .width('80%')
      .height('100%')
    }
    .padding(20)
    .borderRadius(12)
    .backgroundColor('#FFECECEC')
    .height(120)
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
  }
}