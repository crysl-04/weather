export default class CityData {
  public city_name: string;  // 城市名称
  public adcode: number;    // 城市编码（行政区划代码）

  // 构造函数：初始化城市名称和城市编码
  constructor(cityName: string, adcode: number) {
    this.city_name = cityName;
    this.adcode = adcode;
  }
}
