const int currentDbVersion =
    5; //important for update database (android current 1) add 1 each time
const String dbName = "quotes.db";
const List<String> userTables = [
  "user_quotes",
  "saves",
  "likes",
  "user_collections"
];

const String updateDbName = "update_quotes.db";
const String tempDbName = "temp_quotes.db";
const String assetesDbPath = "assets/database/$updateDbName";
