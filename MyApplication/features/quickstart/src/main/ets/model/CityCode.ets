export class CityCode {
  city_name: string = '';
  adcode: number = 0;

  constructor(city_name: string, adcode: number) {
    this.city_name = city_name;
    this.adcode = adcode;
  }
}
