import CityTable from '../common/database/tables/CityTable';

class getCityUtil {

  // // 创建城市表
  // createCityTable() {
  //   const cityTable = new CityTable();
  //   console.log("城市表创建成功！");
  // }

  // // 根据城市名称查询城市编码
  // getCityCode(cityName: string): Promise<number | null> {
  //   return new Promise((resolve, reject) => {
  //     let cityTable = new CityTable();
  //     cityTable.queryCityData(cityName, (cityCode: number) => {
  //       if (cityCode) {
  //         resolve(cityCode);
  //       } else {
  //         resolve(null);
  //       }
  //     });
  //   });
  // }
}

let getcityUtil = new getCityUtil()
export default getcityUtil as getCityUtil
