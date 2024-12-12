import { Views } from '../view/Views';

import { Banner } from '../view/Banner';
import { FoodCultureView } from '../view/FoodCultureView';

import { ArticleDetailPage } from './ArticleDetailPage';
import { ArticleClass } from '../model/ArticleClass';
import { BannerDetailPage } from './BannerDetailPage';
import { BannerClass } from '../model/BannerClass';
import getweatherUtil from '../util/getWeatherUtil'
import {WeatherModel} from '../viewmodel/WeatherModel'

import WeatherData from '../viewmodel/WeatherData';
import WeatherTable from '../common/database/tables/WeatherTable'

import CityTable from '../common/database/tables/CityTable'
import { relationalStore, ValuesBucket } from '@kit.ArkData';
import { bufferToString } from '../util/BufferUtil';
import { CityCode } from '../model/CityCode';
import CityData from '../viewmodel/CityData';

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


  private weatherTable: WeatherTable = new WeatherTable();

  private cityTable: CityTable = new CityTable();

  tabController: TabsController = new TabsController()

  @State message: string = '城市信息';
  @State messages: string = '';
  @State weatherMessage: string = '';
  @State cityMessage: string ='';
  @Builder
  quickStartRouter(name: string, param?: ArticleClass | BannerClass) {
    if (name === 'articleDetail') {
      ArticleDetailPage()
    }else if (name === 'bannerDetailPage') {
      BannerDetailPage()
    }
  }

  @Builder tabBuild(index:number){
    Circle({width:10,height:10})
      .fill(this.cityIndex === index? Color.White:Color.Gray).opacity(0.4)
  }

  aboutToAppear(): void {
    this.initDate()
    this.createDatabase()
    this.getCityCodeDataFromJSON()
    this.insertCityCodeData()

  }
  // @State bannerList: BannerClass[] = [];
  //
  // getBannerDataFromJSON() {
  //   getContext(this).resourceManager.getRawFileContent('BannerData.json').then(value => {
  //
  //     // 获取buffer内容
  //
  //     // 转换为字符串
  //     let res: string =  bufferToString(value);
  //
  //     // 解析为数据结构
  //     this.bannerList = JSON.parse(res) as BannerClass[];
  //
  //     console.info("bannerList:", JSON.stringify(this.bannerList, null, 2));
  //
  //
  //   })
  // }

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
        // Button('删除数据库文件')
        //   // .enabled(false)
        //   .onClick(async () => {
        //     try {
        //       await relationalStore.deleteRdbStore(getContext(), 'RdbTest.db')
        //       AlertDialog.show({ message: '删除成功' })
        //     } catch (error) {
        //       AlertDialog.show({ message: JSON.stringify(error, null, 2) })
        //     }
        //
        //  })
        // Button('创建数据库文件')
        //   .onClick(async () => {
        //     // 获取操作数据库的管理对象(如果数据库文件不存在，会自动创建数据库文件)
        //     const store = await relationalStore.getRdbStore(getContext(), {
        //       name: 'RdbTest.db', // 数据库文件名
        //       securityLevel: relationalStore.SecurityLevel.S1, // 数据库安全级别
        //     })
        //
        //     // 执行创建表的语句 execute 执行
        //     store.executeSql(this.sqlCreate)
        //     AlertDialog.show({ message: '创建成功' })
        //     const id = await store.insert(this.tableName, {
        //       id: null, // 新增时设置 id 为空值 null，用于自增 id
        //       city_name: '北京市',
        //       adcode:110000
        //     } as NodeItem)
        //     AlertDialog.show({ message: '新增数组成功，数据的id为：' + id })
        //   })
        // Button('查询数据库表的字段')
        //   .onClick(async () => {
        //     // 获取操作数据库的对象
        //     const store = await this.getStoreInstance()
        //     // 谓词(条件)，谓词类需要 new 实例化，传入表名 privacy_note
        //     const predicates = new relationalStore.RdbPredicates(this.tableName)
        //     // query 查询，传入必传参数 谓词
        //     const resultSet = await store.query(predicates)
        //     AlertDialog.show({ message: '数据库的字段名：' + resultSet.columnNames })
        //   })
        // Button('新建一条数据')
        //   .onClick(async () => {
        //     // 获取操作数据库的对象
        //     const store = await this.getStoreInstance()
        //     // 添加一条数据
        //     const id = await store.insert(this.tableName, {
        //       id: null, // 新增时设置 id 为空值 null，用于自增 id
        //       city_name: '北京市',
        //       adcode:110000
        //     } as NodeItem)
        //     AlertDialog.show({ message: '新增数组成功，数据的id为：' + id })
        //     // 批量添加，传入数组
        //     // store.batchInsert(表名, 数组)
        //
        //   })

        // Button('查询所有数据')
        //   .onClick(async () => {
        //     // 获取操作数据库的对象
        //     const store = await this.getStoreInstance()
        //     // 谓词（条件）
        //     const predicates = new relationalStore.RdbPredicates(this.tableName)
        //     predicates.orderByDesc('id') // 倒序(由大到小，常用于排序)
        //
        //     // resultSet 结果集
        //     const resultSet = await store.query(predicates)
        //     // 准备一个数组，用于存储数据库提取的数据
        //     const list: NodeItem [] = []
        //     // resultSet.goToNextRow()   指针移动到下一行
        //     while (resultSet.goToNextRow()) {
        //       // 移动指针的时候提取数据，按列下标提取数据
        //       list.push({
        //         id: resultSet.getLong(resultSet.getColumnIndex('id')),
        //         city_name: resultSet.getString(resultSet.getColumnIndex('city_name')),
        //         adcode: resultSet.getLong(resultSet.getColumnIndex('adcode')),
        //         // resultSet.getColumnIndex()        根据列名称获取下标(索引)
        //         // title: resultSet.getString(resultSet.getColumnIndex('title')),
        //         // content: resultSet.getString(resultSet.getColumnIndex('content')),
        //         // date_added: resultSet.getLong(resultSet.getColumnIndex('date_added')),
        //       })
        //     }
        //     AlertDialog.show({ message: JSON.stringify(list, null, 2) })
        //   })Button('查询所有数据')
        //   .onClick(async () => {
        //     // 获取操作数据库的对象
        //     const store = await this.getStoreInstance()
        //     // 谓词（条件）
        //     const predicates = new relationalStore.RdbPredicates(this.tableName)
        //     predicates.orderByDesc('id') // 倒序(由大到小，常用于排序)
        //
        //     // resultSet 结果集
        //     const resultSet = await store.query(predicates)
        //     // 准备一个数组，用于存储数据库提取的数据
        //     const list: NodeItem [] = []
        //     // resultSet.goToNextRow()   指针移动到下一行
        //     while (resultSet.goToNextRow()) {
        //       // 移动指针的时候提取数据，按列下标提取数据
        //       list.push({
        //         id: resultSet.getLong(resultSet.getColumnIndex('id')),
        //         city_name: resultSet.getString(resultSet.getColumnIndex('city_name')),
        //         adcode: resultSet.getLong(resultSet.getColumnIndex('adcode')),
        //         // resultSet.getColumnIndex()        根据列名称获取下标(索引)
        //         // title: resultSet.getString(resultSet.getColumnIndex('title')),
        //         // content: resultSet.getString(resultSet.getColumnIndex('content')),
        //         // date_added: resultSet.getLong(resultSet.getColumnIndex('date_added')),
        //       })
        //     }
        //     AlertDialog.show({ message: JSON.stringify(list, null, 2) })
        //   })
        // Button('删除数据')
        //   .onClick(async () => {
        //     // 获取操作数据库对象
        //     const store = await this.getStoreInstance()
        //     const predicates = new relationalStore.RdbPredicates(this.tableName)
        //     // 注意!!!：记得添加 predicates 限定条件，否者会删除所有数据
        //     // predicates.equalTo('id', 2)        // equalTo 删除一条
        //     predicates.in('id', [1, 2, 3, 4, 5,6,7,8,9]) //  in      批量删除
        //     const affectedRows = await store.delete(predicates)
        //     AlertDialog.show({ message: '受影响行数：' + affectedRows })
        //   })

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
          TextInput({placeholder:"城市名称"})
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
          // TextInput()
          //   .type(InputType.Normal)
          //   .onChange((value) => {
          //     this.cityName = value; // 将输入的城市名称保存到 this.cityName 中
          //   });
          // Button("查询天气")
          //   .borderRadius(8)
          //   .backgroundColor(0x317aff)
          //   .width(130)
          //   .height(40)
          //   .fontSize(20)
          //   .onClick(() => {
          //     if (this.cityName) { // 检查用户是否输入了城市名称
          //       // 调用 queryWeatherData 方法
          //       this.weatherTable.queryWeatherData(this.cityName, (weatherData:WeatherData) => {
          //         if (weatherData) {
          //           // 如果找到天气数据，更新消息
          //           this.message = `城市: ${weatherData.city}\n天气: ${weatherData.weather}\n温度: ${weatherData.temperature}°C\n风向: ${weatherData.winddirection}\n风力: ${weatherData.windpower}\n湿度: ${weatherData.humidity}%\n更新时间: ${weatherData.reporttime}`;
          //         } else {
          //           // 如果未找到数据，显示提示
          //           this.message = "未找到该城市的天气数据。";
          //         }
          //       });
          //     } else {
          //       this.message = "请输入有效的城市名称。"; // 提示用户输入城市名称
          //     }
          //   });
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

          // Button("查询城市编码")
          //   .borderRadius(8)
          //   .backgroundColor(0x317aff)
          //   .width(130)
          //   .height(40)
          //   .fontSize(20)
          //   .onClick(() => {
          //     this.cityTable.queryAllCityData((cityDataList: CityData[]) => {
          //       if (cityDataList.length > 0) {
          //         displayCityData(cityDataList);
          //       } else {
          //         AlertDialog.show({ message: '没有信息!' });
          //       }
          //     });
          //   });

          Banner()
          Views()
          FoodCultureView()
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


function displayCityData(cityDataList: CityData[]) {
  // 构建要显示的消息字符串
  const messages = cityDataList.map(cityData => {
    return `城市: ${cityData.city_name}, 城市编码：${cityData.adcode}`;
  }).join('\n'); // 使用换行符分隔每条记录

  // 使用 AlertDialog 显示结果
  AlertDialog.show({ message: messages });
}