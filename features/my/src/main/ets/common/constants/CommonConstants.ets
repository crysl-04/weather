import { relationalStore } from '@kit.ArkData';
import { DatabaseTable,UsersTable,InstrumentsTable,FavoritesTable } from '../../viewmodel/ConstantsInterface';

export default class CommonConstants {
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

  static readonly INSTRUMENTS_TABLE: InstrumentsTable = {
    tableName: 'instruments',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS instruments(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, type TEXT NOT NULL, brand TEXT NOT NULL, imageUrl TEXT NOT NULL)',
    columns: ['id', 'name', 'type', 'brand', 'imageUrl']
  };

  static readonly FAVORITES_TABLE: FavoritesTable = {
    tableName: 'favorites',
    sqlCreate: 'CREATE TABLE IF NOT EXISTS favorites(id INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER NOT NULL, instrumentId INTEGER NOT NULL, date_added INTEGER NOT NULL, FOREIGN KEY(userId) REFERENCES users(id), FOREIGN KEY(instrumentId) REFERENCES instruments(id))',
    columns: ['id', 'userId', 'instrumentId', 'date_added']
  };

  /**
   * Log tag.
   */
  static readonly RDB_TAG = '[Debug.Rdb]';
  static readonly USERS_TABLE_TAG = '[Debug.UsersTable]';
  static readonly INSTRUMENTS_TABLE_TAG = '[Debug.InstrumentsTable]';
  static readonly FAVORITES_TABLE_TAG = '[Debug.FavoritesTable]';
}
