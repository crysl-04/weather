import { Casts } from "../viewmodel/casts"
@Component
export struct cityView{
  casts:Array<Casts> =[]

  build(){
    Column(){
      ForEach(this.casts,(cast:Casts)=>{
        if(this.casts[0] === cast){
          Column(){
            Row(){
              Text(cast.city).fontSize(20).fontColor(Color.Gray).fontWeight(FontWeight.Bold)
              Text(" "+cast.weather).fontSize(20).fontColor(Color.Gray).fontWeight(FontWeight.Bold)
              Text(" "+cast.temperature+"° ").fontSize(20).fontColor(Color.Gray).fontWeight(FontWeight.Bold)
            }
          }
        }
      })
    }.width("100%").height("100%")

  }
}