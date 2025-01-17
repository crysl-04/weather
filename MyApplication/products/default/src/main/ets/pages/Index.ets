import { QuickStartPage } from '@ohos/quickstart';
import {myPost} from '../myInterface/postInterface';
import { Map } from '@ohos/map';
import { My } from '@ohos/learning';
import router from '@ohos.router';
import promptAction from '@ohos.promptAction';
// import { My } from '@ohos/my';

@Entry
@Component
struct Index {

  //存储一些静态帖子的数据，在尚未添加帖子时就可以展示

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

  onPageShow(){

    if(router.getParams()){

      //得到添加帖子页面返回时传入的动态创建的帖子的数据

      this.postList=(router.getParams() as Record<string, myPost[]>)['postList'];

    }

  }
  @State currentIndex: number = 0;
  private tabsController : TabsController = new TabsController();

  //user
  @State username: string = (router.getParams() as string)['username']
  // @State account: string = '12345678'
  @State itemList: Array<string> = ['个人信息','账户设置', '相关推荐', '联系客服']
  scroller: Scroller = new Scroller();

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

      //分享页面这一tab，页面具体实现在自定义组件share()中
      TabContent() {

        share({postList:this.postList,postBase1:this.postBase1,postBase2:this.postBase2})
      }
      .tabBar(this.tabBarBuilder('分享', 1, $r('app.media.ic_01_on'), $r('app.media.ic_01_off')))
      TabContent() {
        Map()
      }
      .tabBar(this.tabBarBuilder('历史文化', 2, $r('app.media.ic_01_on'), $r('app.media.ic_01_off')))

      TabContent() {
        Scroll(this.scroller)
        {
          // 布局为垂直排列，元素之间有 40 的间距
          Column({ space: 40 }) {
            //页头
            Row({ space: 10 }) {
              Image('https://kkimgs.yisou.com/ims?kt=url&at=ori&key=aHR0cHM6Ly93d3cuaHIubmV0LmNuL2RhdGEvdXBsb2FkL2NvbXBhbnkvMjAyMDAzMDQvMTU4NDA3NTgwMzguanBlZw==&sign=yx:kOTKzZQzp6DSWNSQd4Majx04zTA=&tv=0_0')
                .layoutWeight(2)
              Text('账号中心')
                .fontSize(34)
                .textAlign(TextAlign.Start)
                .layoutWeight(10)
              Image('https://kkimgs.yisou.com/ims?kt=url&at=ori&key=aHR0cDovL2h1YWNhaWl2eW91LnJvbmdzb2Z0LmNvbS91cGxvYWQvaW1nLzIwMjAwOS80Y2ZiOGM4NjliYTE0OWIwOTE0OWYzOWZiYTM3NGU0NS5qcGc=&sign=yx:_jy-IsZRvrU-d1HYXqTE3q8haMY=&tv=0_0')
                .layoutWeight(2)
            }
            .height(45)
            .width('95%')
            .margin({ top: -5, left: 10 })

            // 用户头像和信息部分
            Row({ space: 25 }) {
              Image($r('app.media.logo'))
                .width(60)
                .borderRadius(30)
              Column({ space: 6 }) {
                Text(this.username)
                  .fontWeight(FontWeight.Bold)
                  .fontSize(22)
                  .margin({ top: 0, left: -60 })
                // Text('账号: ' + this.account)
                //   .fontSize(18)
                //   .fontColor(Color.Grey)
              }
            }
            .margin({ top: 0, left: -50, bottom: 50 })
            .width('75%')

            // 功能列表
            List({ space: 10 }) {
              // 遍历 itemList 数组生成列表项
              ForEach(this.itemList, (item: string, index: number) => {
                ListItem() {
                  Row({}) {
                    Text(item)
                      .fontSize(22)
                      .fontColor('#800080')
                      .padding(6)
                      .width('100%')
                  }
                  .width('100%')
                  .justifyContent(FlexAlign.Center)
                  .height(40)
                  .backgroundColor(Color.White) //'#F5F5F5'
                  .borderRadius(12)
                }
              })
            }.width('95%').height(250)
            .margin({ bottom: 30, right: -10 })

            // 操作按钮部分
            Button('切换账号')
              .width(200)
              .backgroundColor(Color.Red)
              .margin({ bottom: -20 })
              .clickEffect({ level: ClickEffectLevel.HEAVY })  //按钮点击动效
              .onClick(()=>{router.pushUrl({
                url: 'pages/Login'
              })})
            Button('退出登录')
              .width(200)
              .backgroundColor(Color.Red)
              .onClick(()=>{router.pushUrl({
                url: 'pages/Login'
              })})

          }
        }
        .scrollable(ScrollDirection.Vertical) // 滚动方向为垂直方向
        .scrollBar(BarState.On) // 滚动条常驻显示
        .scrollBarColor(Color.Gray) // 滚动条颜色
        .scrollBarWidth(10) // 滚动条宽度
        .edgeEffect(EdgeEffect.Spring) // 滚动到边沿后回弹

      }
      .tabBar(this.tabBarBuilder('我的', 3, $r('app.media.ic_01_on'), $r('app.media.ic_01_off')))

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
  //用于得到可滑动效果需要设置的参数
  @State rotateAngle: number = 0;
  @State speed: number = 1;

  @Link  postList:myPost[]
  @Link postBase1:myPost[]
  @Link postBase2:myPost[]

  build(){
    Column(){
      Row(){

        //标题

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

        //加号按钮，点击可以新建帖子

        Button('+', { type: ButtonType.Capsule, stateEffect: true })

          .fontSize('16fp')
          .width('50vp')
          .height('50vp')
          .backgroundColor('#FF69B4')
          .fontColor('#FFFFFF')
          .borderRadius('25vp')
          .onClick(async () => {

            //点击后进入添加帖子的页面
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

      }
      //原本就有的静态帖子：
      List(){
        ForEach(this.postBase1,(item:myPost,index:number)=>{
          ListItem(){
            Row(){
              onePost({ item: item,PictureSource:'app.media.shanghai' })
                .margin({ top: 10 })
            }

            .height('20%')
            .width('100%')
          }
          .padding(5)
          .onClick(() => {
            //点击查看post具体内容，跳转到帖子详情页面
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
            }

            .height('20%')
            .width('100%')
          }
          .padding(5)
          .onClick(() => {

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

      //展示动态创建的帖子
      //遍历所有存储的列表中的项
      List(){
        ForEach(this.postList,(item:myPost,index:number)=>{
          ListItem(){
            Row(){
              //具体布局在onePost组件中
              onePost({ item: item,PictureSource:'app.media.myPicture' })
                .margin({ top: 10 })
            }

            .height('20%')
            .width('100%')
          }
          .padding(5)
          .onClick(() => {
            //点击查看post具体内容

            router.pushUrl({
              url: "pages/postDetail",
              params: {
                picture:'app.media.myPicture',
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
    .gesture(
      // 绑定滑动手势且限制仅在竖直方向滑动时触发
      SwipeGesture({ direction: SwipeDirection.Vertical })

        .onAction((event: GestureEvent) => {
          this.speed = event.speed;
          this.rotateAngle = event.angle;
        })
    )
  }
}
@Component
struct onePost{
  @Prop item:myPost
  @Prop PictureSource:string
  build() {
    //布局有图片、文字
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
        Row() {
          Text(this.item.city)
            .fontSize(16)
            .fontColor(Color.Gray)
            .margin({ bottom: 8 })
          Image($r('app.media.icon'))
            .width(50)
            .height(50)
            .margin({ right: 20 })
          Image($r('app.media.say'))
            .width(30)
            .height(30)
            .margin({ right: 20 })

        }
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