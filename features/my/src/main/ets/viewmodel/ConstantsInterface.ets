
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

/**
 * Interface for the Instruments table.
 */
export interface InstrumentsTable {
  tableName: string;
  sqlCreate: string;
  columns: string[];
}

/**
 * Interface for the Favorites table.
 */
export interface FavoritesTable {
  tableName: string;
  sqlCreate: string;
  columns: string[];
}
