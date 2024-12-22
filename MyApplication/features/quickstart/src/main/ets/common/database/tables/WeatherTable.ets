import { relationalStore } from '@kit.ArkData';
import CommonConstants from '../../constants/CommonConstants';
import Rdb from '../Rdb';
import WeatherData from '../../../viewmodel/WeatherData';

export default class WeatherTable {
  private weatherTable = new Rdb(CommonConstants.WEATHER_TABLE.tableName, CommonConstants.WEATHER_TABLE.sqlCreate,
    CommonConstants.WEATHER_TABLE.columns);

  constructor(callback: Function = () => {}) {
    this.weatherTable.getRdbStore(callback);
  }

  getRdbStore(callback: Function = () => {}) {
    this.weatherTable.getRdbStore(callback);
  }

  insertWeatherData(weatherData: WeatherData, callback:  (success: boolean) => void):void {
    const valueBucket: relationalStore.ValuesBucket = {
      city: weatherData.city,
      weather: weatherData.weather,
      temperature: weatherData.temperature,
      winddirection: weatherData.winddirection,
      windpower: weatherData.windpower,
      humidity: weatherData.humidity,
      reporttime: weatherData.reporttime
    };
    this.weatherTable.insertData(valueBucket, callback);
  }

  deleteWeatherData(city: string, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.WEATHER_TABLE.tableName);
    predicates.equalTo('city', city);
    this.weatherTable.deleteData(predicates, callback);
  }

  deleteAllWeatherData(callback: (result: boolean) => void): void {
    // 创建一个没有条件的 RdbPredicates 实例，表示删除所有数据
    const predicates = new relationalStore.RdbPredicates(CommonConstants.WEATHER_TABLE.tableName);
    this.weatherTable.deleteData(predicates, callback);
  }


  updateWeatherData(city: string, weatherData: WeatherData, callback: Function) {
    const valueBucket: relationalStore.ValuesBucket = {
      weather: weatherData.weather,
      temperature: weatherData.temperature,
      winddirection: weatherData.winddirection,
      windpower: weatherData.windpower,
      humidity: weatherData.humidity,
      reporttime: weatherData.reporttime
    };
    let predicates = new relationalStore.RdbPredicates(CommonConstants.WEATHER_TABLE.tableName);
    predicates.equalTo('city', city);
    this.weatherTable.updateData(predicates, valueBucket, callback);
  }

  queryWeatherData(city: string, callback: Function) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.WEATHER_TABLE.tableName);
    predicates.equalTo('city', city);
    this.weatherTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0) {
        console.log(`${CommonConstants.WEATHER_TABLE_TAG}` + 'Query no results!');
        callback(null);
      } else {
        resultSet.goToFirstRow();
        const weatherData = new WeatherData(
          resultSet.getString(resultSet.getColumnIndex('city')),
          resultSet.getString(resultSet.getColumnIndex('weather')),
          resultSet.getDouble(resultSet.getColumnIndex('temperature')),
          resultSet.getString(resultSet.getColumnIndex('winddirection')),
          resultSet.getString(resultSet.getColumnIndex('windpower')),
          resultSet.getDouble(resultSet.getColumnIndex('humidity')),
          resultSet.getString(resultSet.getColumnIndex('reporttime'))
        );
        callback(weatherData);
      }
    });
  }

  queryAllWeatherData(callback: Function) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.WEATHER_TABLE.tableName);
    // 不设置任何条件，以查询所有记录
    this.weatherTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0) {
        console.log(`${CommonConstants.WEATHER_TABLE_TAG}` + 'Query no results!');
        callback([]);
      } else {
        const weatherDataList: WeatherData[] = []; // 明确指定数组类型为 WeatherData[]
        resultSet.goToFirstRow();

        // 遍历所有行
        do {
          const weatherData = new WeatherData(
            resultSet.getString(resultSet.getColumnIndex('city')),
            resultSet.getString(resultSet.getColumnIndex('weather')),
            resultSet.getDouble(resultSet.getColumnIndex('temperature')),
            resultSet.getString(resultSet.getColumnIndex('winddirection')),
            resultSet.getString(resultSet.getColumnIndex('windpower')),
            resultSet.getDouble(resultSet.getColumnIndex('humidity')),
            resultSet.getString(resultSet.getColumnIndex('reporttime'))
          );
          weatherDataList.push(weatherData); // 将每条天气数据添加到列表中
        } while (resultSet.goToNextRow()); // 继续到下一行

        callback(weatherDataList); // 返回所有天气数据记录
      }
    });
  }


}
