import { Views } from '../view/Views';

import { Banner } from '../view/Banner';
import { FoodCultureView } from '../view/FoodCultureView';

import { ArticleDetailPage } from './ArticleDetailPage';
import { ArticleClass } from '../model/ArticleClass';
import { BannerDetailPage } from './BannerDetailPage';
import { BannerClass } from '../model/BannerClass';
import getweatherUtil from '../util/getWeatherUtil'
import getlocUtil from '../util/getLocUtil'
import getrouteUtil from '../util/getRouteUtil'
import { Location } from '../util/getRouteUtil';  // 导入 Location 接口

import {WeatherModel} from '../viewmodel/WeatherModel'

import WeatherData from '../viewmodel/WeatherData';
import WeatherTable from '../common/database/tables/WeatherTable'

import CityTable from '../common/database/tables/CityTable'
import { relationalStore, ValuesBucket } from '@kit.ArkData';
import { bufferToString } from '../util/BufferUtil';
import { CityCode } from '../model/CityCode';

interface NodeItem extends ValuesBucket{
  id: number | null
  city_name :string
  adcode:number
}


@Component
export struct QuickStartPage {
  tableName: string = 'City'

  sqlCreate: string = `CREATE TABLE IF NOT EXISTS ${this.tableName} (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        city_name TEXT NOT NULL,
        adcode INTEGER NOT NULL
      )`
  // 操作数据库的管理对象
  store: relationalStore.RdbStore | null = null

  async getStoreInstance() {
    // 如果已经存在，直接返回
    if (this.store) {
      return this.store
    }
    // 获取操作数据库的管理对象(如果数据库文件不存在，会自动创建数据库文件)
    this.store = await relationalStore.getRdbStore(getContext(), {
      name: 'RdbTest.db', // 数据库文件名
      securityLevel: relationalStore.SecurityLevel.S1, // 数据库安全级别
    })
    // 执行创建表的语句 execute 执行
    this.store.executeSql(this.sqlCreate)
    // 返回 store 对象
    return this.store
  }

  @Provide('articlePathStack') articlePathStack: NavPathStack = new NavPathStack();
  @State cityCodeList: number[] =[320500]
  @State cityNameList :string[] = []
  @State cityWeatherList : Array<WeatherModel>=[]
  @State cityIndex : number=0
  @State cityCode : number = 320500
  @State cityName : string = ""
  @State queryName : string =""
  @State cityAdcodeList: Array<CityCode>=[]

  @State startName : string =	"北京市朝阳区建国门外大街21号88A"
  @State endName : string ="北京市朝阳区建国门外大街59号"
  @State startlong: number =116.434307
  @State startlati: number =39.90909
  @State endlong: number =116.434446
  @State endlati: number =39.90816




  private weatherTable: WeatherTable = new WeatherTable();

  private cityTable: CityTable = new CityTable();

  tabController: TabsController = new TabsController()

  @State message: string = '城市信息';
  @State messages: string = '';
  @State weatherMessage: string = '';
  @State cityMessage: string ='';
  @Builder
  quickStartRouter(name: string, param?: ArticleClass ){
    //| BannerClass) {
    if (name === 'articleDetail') {
      ArticleDetailPage()
    }
    // else if (name === 'bannerDetailPage') {
    //   BannerDetailPage()
    // }
  }

  @Builder tabBuild(index:number){
    Circle({width:10,height:10})
      .fill(this.cityIndex === index? Color.White:Color.Gray).opacity(0.4)
  }

  aboutToAppear(): void {
    // this.initDate()
    this.createDatabase()
    this.getCityCodeDataFromJSON()
    // this.insertCityCodeData()

  }


  async insertCityCodeData() {
    try {
      // 调用插入默认城市的函数
      this.cityTable.insertDefaultCities();

      // 插入成功后打印成功信息
      console.log("城市编码数据插入成功！");
    } catch (error) {
      // 捕获错误并打印错误信息
      console.error("插入城市编码数据失败:", error);
    }
  }


  async getCityCodeDataFromJSON() {
    getContext(this).resourceManager.getRawFileContent('CityCodeData.json').then(async value => {
      let fileContent:string = bufferToString(value);
      console.info("File content length:", fileContent.length);
      console.info("File content preview:", fileContent.slice(0, 104)); // 打印整个文件内容

      console.info("Raw file content:", fileContent);  // 打印文件原始内容

      // 如果文件内容为空，直接返回
      if (!fileContent) {
        console.error("File content is empty.");
        return;
      }

      // 解析 JSON 数据
      this.cityAdcodeList = JSON.parse(fileContent) as CityCode[];

      console.info("City Adcode List:", JSON.stringify(this.cityAdcodeList, null, 2));

      const store = await this.getStoreInstance();

      this.cityAdcodeList.forEach(async city => {
        console.info(`City: ${city.city_name}, Adcode: ${city.adcode}`);
        await store.insert(this.tableName,{
          id:null,
          city_name:city.city_name,
          adcode:city.adcode
        })
        console.info(`Inserted city: ${city.city_name}, Adcode: ${city.adcode}`);
      });
    });
  }

  async createDatabase(){
    await relationalStore.deleteRdbStore(getContext(), 'RdbTest.db')

    const store = await relationalStore.getRdbStore(getContext(),{
      name: 'RdbTest.db',
      securityLevel:relationalStore.SecurityLevel.S1
    });
    // 执行创建表的语句 execute 执行
    store.executeSql(this.sqlCreate);
    // AlertDialog.show({ message: '创建成功' });
  }

  async initDate(){
    let result: Array<WeatherModel> = await getweatherUtil.getWeathers(this.cityCodeList);

    for(let i = 0; i < result.length;i++){
      let ACityWeather = new WeatherModel()
      ACityWeather = result[i]
      this.cityWeatherList.push(ACityWeather)
      let cityName = result[i].lives[0].city
      this.cityNameList.push(cityName)
    }

  }




  async queryAdcodeByCity(cityName: string):Promise<number|null>{
    const store = await this.getStoreInstance();
    const predicates = new relationalStore.RdbPredicates(this.tableName);
    predicates.equalTo('city_name', cityName);
    const resultSet = await store.query(predicates);
    if (resultSet.goToNextRow()) {
      // 返回查询到的 adcode
      return resultSet.getLong(resultSet.getColumnIndex('adcode'));
    } else {
      // 没有找到对应的记录，返回 null
      return null;
    }
  }

  build() {
    Navigation(this.articlePathStack) {
      Column() {

        Text(this.message)
          .id('Hello')
          .fontSize(24)
          .fontWeight('700')
          .width('100%')
          .textAlign(TextAlign.Start)
          .padding({ left: 16 })
          .fontFamily('HarmonyHeiTi-Bold')
          .lineHeight(33)
        Scroll() {
          Column() {
            // 用户输入城市名称的 TextInput 组件
            TextInput({placeholder:"请输入城市名称"})
              .type(InputType.Normal)
              .onChange((value) => {
                this.queryName = value;  // 将输入的城市名称保存到 this.cityName 中
              });
            // 查询按钮
            Button("查询城市编码")
              .borderRadius(8)
              .backgroundColor(0x317aff)
              .width(200)
              .height(40)
              .fontSize(20)
              .onClick(async () => {
                // 调用查询函数
                const adcode = await this.queryAdcodeByCity(this.queryName);

                if (adcode !== null) {11
                  // 显示查询结果
                  AlertDialog.show({ message: `城市 ${this.queryName} 对应的 adcode 是：${adcode}` });
                }
              });
            TextInput({placeholder:"请输入城市编码"})
              .type(InputType.Number)
              .onChange((value) => {
                this.cityCode = Number(value); // 将字符串转换为数字并更新城市编码
              });
            Button("获取天气")
              .borderRadius(8)
              .backgroundColor(0x317aff)
              .width(130)
              .height(40)
              .fontSize(20)
              .onClick(() => {
                if (this.cityCode) { // 检查用户是否输入了编码
                  // 调用getWeather函数
                  getweatherUtil.getWeather(Number(this.cityCode)).then((weather) => {
                    // 处理成功获取天气信息后的逻辑
                    const liveData = weather.lives[0]; // 获取第一个天气信息
                    AlertDialog.show({ message:`城市: ${liveData.city}\n天气: ${liveData.weather}\n温度: ${liveData.temperature}°C\n风向: ${liveData.winddirection}\n风力: ${liveData.windpower}\n湿度: ${liveData.humidity}%\n更新时间: ${liveData.reporttime}` });

                    const weatherData = new WeatherData(
                      liveData.city,
                      liveData.weather,
                      liveData.temperature,
                      liveData.winddirection,
                      liveData.windpower,
                      liveData.humidity,
                      liveData.reporttime
                    );
                    this.weatherTable.insertWeatherData(weatherData, (success:boolean) => {
                      if (success) {
                        console.log("天气数据已存储到数据库");
                      } else {
                        console.error("存储天气数据失败");
                      }
                    });

                  }).catch((error:Error) => {
                    // 处理错误
                    console.error("获取天气失败:", error);
                    this.message = "获取天气失败，请稍后再试。";
                  });
                } else {
                  this.message = "请输入有效的城市编码。"; // 提示用户输入编码
                }
              });

            Row(){
              Button("查询历史记录")

                .onClick(() => {
                  this.weatherTable.queryAllWeatherData((weatherDataList: WeatherData[]) => {
                    if (weatherDataList.length > 0) {
                      displayWeatherData(weatherDataList);
                    } else {
                      AlertDialog.show({ message: '没有历史天气记录!' });
                    }
                  });
                });
              Button('删除查询记录').onClick(() => {
                this.weatherTable.deleteAllWeatherData((result:boolean) => {
                  if (result) {
                    AlertDialog.show({ message: '所有历史查询记录已成功删除！' });
                  } else {
                    AlertDialog.show({ message: '删除历史查询记录失败！' });
                  }
                });
              });

            }

            // Banner()
            // Views()
            // FoodCultureView()

            // 用户输入出发地点的 TextInput 组件
            TextInput({placeholder:"请输入出发地"})
              .type(InputType.Normal)
              .onChange((value) => {
                this.startName = value;  // 将输入的出发地保存到 this.startName 中

              });
            // 查询按钮
            Button("查询经纬度坐标")
              .borderRadius(8)
              .backgroundColor(0x317aff)
              .width(200)
              .height(40)
              .fontSize(20)
              .onClick(async () => {
                // 调用 getLoc 查询经纬度
                try {
                  const location = await getlocUtil.getLoc(this.startName); // 调用getLoc函数并传入地址
                  if (location) {
                    // 手动拆分 location 字符串
                    // 直接访问对象属性而不使用解构
                    const longitude = location.longitude;
                    this.startlong = location.longitude;
                    const latitude = location.latitude;
                    this.startlati = location.latitude;

                    // 显示查询结果
                    AlertDialog.show({ message: `经纬度坐标：\n经度: ${longitude}\n纬度: ${latitude}` });
                  } else {
                    // 没有找到对应的经纬度
                    AlertDialog.show({ message: "未找到该地址的经纬度信息。" });
                  }
                } catch (error) {
                  // 错误处理
                  AlertDialog.show({ message: `查询经纬度时出错: ${error.message}` });
                }
              });
            // 用户输入出发地点的 TextInput 组件
            TextInput({placeholder:"请输入目的地"})
              .type(InputType.Normal)
              .onChange((value) => {
                this.endName = value;  // 将输入的出发地保存到 this.startName 中
              });
            // 查询按钮
            Button("查询经纬度坐标")
              .borderRadius(8)
              .backgroundColor(0x317aff)
              .width(200)
              .height(40)
              .fontSize(20)
              .onClick(async () => {
                // 调用 getLoc 查询经纬度
                try {
                  const location = await getlocUtil.getLoc(this.endName); // 调用getLoc函数并传入地址
                  if (location) {
                    // 手动拆分 location 字符串
                    // 直接访问对象属性而不使用解构
                    const longitude = location.longitude;
                    this.endlong = location.longitude;
                    const latitude = location.latitude;
                    this.endlati = location.latitude;

                    // 显示查询结果
                    AlertDialog.show({ message: `经纬度坐标：\n经度: ${longitude}\n纬度: ${latitude}` });
                  } else {
                    // 没有找到对应的经纬度
                    AlertDialog.show({ message: "未找到该地址的经纬度信息。" });
                  }
                } catch (error) {
                  // 错误处理
                  AlertDialog.show({ message: `查询经纬度时出错: ${error.message}` });
                }
              });

            // 查询路径规划按钮
            Button("查询步行路径规划")
              .borderRadius(8)
              .backgroundColor(0x317aff)
              .width(200)
              .height(40)
              .fontSize(20)
              .onClick(async () => {
                try {
                  // 查询起点的经纬度
                  const startLocation = await getlocUtil.getLoc(this.startName);
                  if (!startLocation) {
                    AlertDialog.show({ message: `未找到地址 "${this.startName}" 的经纬度信息。` });
                    return;
                  }

                  // 查询终点的经纬度
                  const endLocation = await getlocUtil.getLoc(this.endName);
                  if (!endLocation) {
                    AlertDialog.show({ message: `未找到地址 "${this.endName}" 的经纬度信息。` });
                    return;
                  }

                  // 保存起点和终点经纬度
                  this.startlong = startLocation.longitude;
                  this.startlati = startLocation.latitude;
                  this.endlong = endLocation.longitude;
                  this.endlati = endLocation.latitude;

                  // 调用路径规划
                  const routeResponse = await getrouteUtil.getWalkingRoute(
                    { longitude: this.startlong, latitude: this.startlati },
                    { longitude: this.endlong, latitude: this.endlati }
                  );

                  if (routeResponse && routeResponse.route) {
                    // 显示路径规划结果
                    let message = `从 ${this.startName} 到 ${this.endName} 的路径规划结果：\n`;

                    routeResponse.route.paths.forEach((path, index) => {
                      message += `路径 ${index + 1}:\n`;
                      path.steps.forEach((step, stepIndex) => {
                        message += `  第${stepIndex + 1}步: ${step.instruction} 距离: ${step.distance} 时间: ${step.duration}\n`;
                      });
                    });

                    AlertDialog.show({ message: message });
                  } else {
                    AlertDialog.show({ message: "未找到有效的路径规划结果。" });
                  }
                } catch (error) {
                  AlertDialog.show({ message: `查询路径规划时出错: ${error.message}` });
                }
              });
          }
        }
        .layoutWeight(1)
        .scrollBar(BarState.Off)
        .align(Alignment.TopStart)
      }
      .height('100%')
      .width('100%')
      .backgroundColor('#F1F3F5')
    }
    .navDestination(this.quickStartRouter)
    .hideTitleBar(true)
    .mode(NavigationMode.Stack)
  }
}

function displayWeatherData(weatherDataList: WeatherData[]) {
  // 构建要显示的消息字符串
  const messages = weatherDataList.map(weatherData => {
    return `城市: ${weatherData.city}, 天气: ${weatherData.weather}, 温度: ${weatherData.temperature}°C, 风向: ${weatherData.winddirection}, 风力: ${weatherData.windpower}, 湿度: ${weatherData.humidity}%, 报告时间: ${weatherData.reporttime}`;
  }).join('\n'); // 使用换行符分隔每条记录

  // 使用 AlertDialog 显示结果
  AlertDialog.show({ message: messages });
}

