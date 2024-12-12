export default class WeatherData {
  public city: string;
  public weather: string;
  public temperature: number;
  public winddirection: string;
  public windpower: string;
  public humidity: number;
  public reporttime: string;

  constructor(city: string, weather: string, temperature: number,
  winddirection: string, windpower: string, humidity: number,
  reporttime: string) {
  this.city = city;
  this.weather = weather;
  this.temperature = temperature;
  this.winddirection = winddirection;
  this.windpower = windpower;
  this.humidity = humidity;
  this.reporttime = reporttime;
}
}
