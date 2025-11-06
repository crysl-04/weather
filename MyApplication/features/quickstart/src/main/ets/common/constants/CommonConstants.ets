import { relationalStore } from '@kit.ArkData';
import { UsersTable,WeatherTable ,CityTable} from '../../viewmodel/ConstantsInterface';
import ApiConfig from '../config/ApiConfig';

export default class CommonConstants {
  static readonly WEATHER_TABLE: WeatherTable = {
    tableName: 'WeatherRecords',
    sqlCreate: `CREATE TABLE IF NOT EXISTS WeatherRecords (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      city TEXT,
      weather TEXT,
      temperature REAL,
      winddirection TEXT,
      windpower TEXT,
      humidity REAL,
      reporttime TEXT
    )`,
    columns: ['id', 'city', 'weather', 'temperature', 'winddirection', 'windpower', 'humidity', 'reporttime'],
  };

  static readonly CITY_TABLE: CityTable = {
    tableName: 'CityRecords',  // 表名
    sqlCreate: `CREATE TABLE IF NOT EXISTS CityRecords (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    cityName TEXT,
    adcode TEXT
  )`,  // SQL创建表的语句
    columns: ['id', 'cityName', 'adcode'],  // 表的列
  };

  /**
   * Rdb database config.
   */
  static readonly STORE_CONFIG: relationalStore.StoreConfig = {
    name: 'database.db',
    securityLevel: relationalStore.SecurityLevel.S1
  };

  static readonly USERS_TABLE: UsersTable = {
    tableName: 'users',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY AUTOINCREMENT, username TEXT NOT NULL, email TEXT NOT NULL)',
    columns: ['id', 'username', 'email']
  };


  /**
   * Log tag.
   */
  static readonly RDB_TAG = '[Debug.Rdb]';
  static readonly USERS_TABLE_TAG = '[Debug.UsersTable]';
  static  readonly  WEATHER_TABLE_TAG: 'WeatherTable';
  static  readonly  CITY_TABLE_TAG: 'CityTable';

  /**
   * 高德地图API配置
   * ⚠️ 安全提示：API key从ApiConfig.ets文件中读取，请确保已正确配置
   */
  static readonly AMAP_API_KEY: string = ApiConfig.AMAP_API_KEY;

}
