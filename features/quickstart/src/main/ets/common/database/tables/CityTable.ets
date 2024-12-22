import { relationalStore } from '@kit.ArkData';
import CommonConstants from '../../constants/CommonConstants';
import Rdb from '../Rdb';
import CityData from '../../../viewmodel/CityData';

export default class CityTable {

  private cityTable = new Rdb(
    CommonConstants.CITY_TABLE.tableName,
    CommonConstants.CITY_TABLE.sqlCreate,
    CommonConstants.CITY_TABLE.columns
  );

  constructor(callback: Function = () => {}) {
    // 获取 RdbStore
    this.cityTable.getRdbStore(callback);
  }

  getRdbStore(callback: Function = () => {}) {
    this.cityTable.getRdbStore(callback);
  }

  // 插入默认城市数据
  insertDefaultCities(): void {
    // 默认城市数据列表
    const defaultCities = [
      new CityData('南京', 320100),
      new CityData('北京', 110100),
      new CityData('上海', 310100),
      new CityData('广州', 440100)
    ];

    // 插入每一条城市数据
    defaultCities.forEach((cityData) => {
      this.insertCityData(cityData, (success) => {
        if (success) {
          console.log(`城市 ${cityData.city_name} 插入成功！`);
        } else {
          console.error(`城市 ${cityData.city_name} 插入失败！`);
        }
      });
    });
  }

  // 插入城市数据
  insertCityData(cityData: CityData, callback: (success: boolean) => void): void {
    const valueBucket: relationalStore.ValuesBucket = {
      city_name: cityData.city_name,
      adcode: cityData.adcode,
    };
    this.cityTable.insertData(valueBucket, callback);
  }

  // 删除城市数据
  deleteCityData(cityName: string, callback: Function): void {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.CITY_TABLE.tableName);
    predicates.equalTo('city_name', cityName);
    this.cityTable.deleteData(predicates, callback);
  }

  // 更新城市数据
  updateCityData(cityName: string, cityData: CityData, callback: Function): void {
    const valueBucket: relationalStore.ValuesBucket = {
      adcode: cityData.adcode,
    };
    let predicates = new relationalStore.RdbPredicates(CommonConstants.CITY_TABLE.tableName);
    predicates.equalTo('city_name', cityName);
    this.cityTable.updateData(predicates, valueBucket, callback);
  }

  // 查询城市数据
  queryCityData(cityName: string, callback: Function): void {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.CITY_TABLE.tableName);
    predicates.equalTo('city_name', cityName);
    this.cityTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0) {
        console.log(`${CommonConstants.CITY_TABLE_TAG} Query no results!`);
        callback(null);
      } else {
        resultSet.goToFirstRow();
        const cityData = new CityData(
          resultSet.getString(resultSet.getColumnIndex('city_name')),
          resultSet.getLong(resultSet.getColumnIndex('adcode'))
        );
        callback(cityData);
      }
    });
  }

  queryAllCityData(callback: Function) {
    let predicates = new relationalStore.RdbPredicates(CommonConstants.CITY_TABLE.tableName);
    // 不设置任何条件，以查询所有记录
    this.cityTable.query(predicates, (resultSet: relationalStore.ResultSet) => {
      let count: number = resultSet.rowCount;
      if (count === 0) {
        console.log(`${CommonConstants.CITY_TABLE_TAG}` + 'Query no results!');
        callback([]);
      } else {
        const cityDataList: CityData[] = [];
        resultSet.goToFirstRow();

        // 遍历所有行
        do {
          const cityData = new CityData(
            resultSet.getString(resultSet.getColumnIndex('city_name')),
            resultSet.getDouble(resultSet.getColumnIndex('adcode'))
          )
          cityDataList.push(cityData)

        } while (resultSet.goToNextRow()); // 继续到下一行

        callback(cityDataList); // 返回所有天气数据记录
      }
    });
  }
}
