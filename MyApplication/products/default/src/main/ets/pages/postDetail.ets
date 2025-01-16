import router from '@ohos.router';
import { curves } from '@kit.ArkUI';
@Entry
@Component
export struct PostDetail {

  //帖子详情页面
  //获取跳转进入时传入的该条帖子相关数据

  @State title: string = (router.getParams() as Record<string, string>)['title'];
  @State city :string= (router.getParams() as Record<string, string>)['city'];
  @State contents:string = (router.getParams() as Record<string, string>)['contents'];
  @State picture:string=(router.getParams() as Record<string, string>)['picture'];

  @State rotateAngle: number = 0;
  @State speed: number = 1;

  //转场动画效果设置
  private effect: TransitionEffect =

    TransitionEffect.OPACITY.animation({ curve: curves.springMotion(0.6, 0.8) })

      .combine(TransitionEffect.scale({ x: 0, y: 0 }))

      .combine(TransitionEffect.rotate({ angle: 90 }))

      .combine(TransitionEffect.translate({ y: 150 }).animation({ curve: curves.springMotion() }))

      .combine(TransitionEffect.move(TransitionEdge.END))

  build() {
    Column() {
      Row() {
        //返回按钮
        Button('<', { type: ButtonType.Capsule, stateEffect: true })

          .fontSize('16fp')
          .width('50vp')
          .height('50vp')
          .alignSelf(0)
          .backgroundColor('#FF69B4')
          .fontColor('#FFFFFF')
          .borderRadius('25vp')
          .onClick(async () => {
            router.back({
              //点击回到原来的页面
              url: "pages/Index"
            })
          })
        Blank().width(20)
        //展示标题
        Text(this.title)
          .fontSize(20)
          .margin({ bottom: 8 })
          // .fontFamily('HarmonyHeiTi-Bold')
          .fontFamily('Lora')
          .fontWeight('bold')
          .letterSpacing(1.5)

      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      Blank()

      Column(){
        //展示图片
        Image($r(this.picture))
          .width('100%')
          .height(200)
          .margin({ right: 20 })
      }
      Blank()
        .height(30)
      Scroll() {
        //展示可滚动查阅的文本内容
        Column() {
          Text(this.contents)
            .fontFamily('Lora')
            .fontSize(16)
            .fontColor(Color.Gray)
            .margin({ bottom: 16 })
            .width('100%')
            .gesture(
              // 绑定滑动手势且限制仅在竖直方向滑动时触发
              SwipeGesture({ direction: SwipeDirection.Vertical })

                .onAction((event: GestureEvent) => {
                  this.speed = event.speed;
                  this.rotateAngle = event.angle;
                })
            )
          Image($r('app.media.heart'))
            .width(80)
            .height(80)
            .margin({ right: 20 })



        }
      }
      .height('100%')
      .width('100%')

    }
    //添加转场动画效果
    .transition(this.effect)

  }
}
