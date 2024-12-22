
/**
 * Interface for database tables.
 */
export interface DatabaseTable {
  tableName: string;
  sqlCreate: string;
  columns: string[];
}

/**
 * Interface for the Users table.
 */
export interface UsersTable {
  tableName: string;
  sqlCreate: string;
  columns: string[];
}



export interface WeatherTable {
  tableName: string;
  sqlCreate: string;
  columns: string[];
}

export interface CityTable {
  tableName: string;
  sqlCreate: string;
  columns: string[];
}