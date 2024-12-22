import {WeatherModel} from "../viewmodel/WeatherModel"
import http from '@ohos.net.http';





class getWeatherUtil{


  getWeather(cityCode:number){
    return new Promise<WeatherModel>((resolve,reject)=>{
      //创建
      let request = http.createHttp()
      let url= `https://restapi.amap.com/v3/weather/weatherInfo?city=${cityCode}&key=2bacbe5e2e3d8c30eca80abc98b93672&extensions=base`

      let options = {
        method:http.RequestMethod.GET,
        header:{'Content-Type':'application/json'},
      } as http.HttpRequestOptions
      let result = request.request(url,options)

      result.then((res)=>{
        if (res.responseCode === 200) {
          console.log(res.result.toString())
          resolve( JSON.parse(res.result.toString()))
        }
      }).catch(reject)
    })
  }

  //直接获取所有数据
  async  getWeathers (cityCodeList:Array<number>){
    let weatherModels: Array<WeatherModel> = []
    let promises :Array<Promise<WeatherModel>> = []
    for (let i = 0; i < cityCodeList.length; i++) {
      promises.push(this.getWeather(cityCodeList[i]))
    }
    await Promise.all(promises).then(result =>{
      for (const element of result) {
        console.log(element.lives[0]?.city || "City not found.");
      }
      weatherModels = result
    })
    return weatherModels
  }
}

let getweatherUtil = new getWeatherUtil()
export default getweatherUtil as getWeatherUtil