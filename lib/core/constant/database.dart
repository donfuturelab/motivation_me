const int currentDbVersion =
    2; //important for update database (android current 1) add 1 each time last 5
//please check main for update db version and reset selected category
const String dbName = "quotes.db";
const List<String> userTables = [
  "user_quotes",
  "saves",
  "likes",
  "user_collections"
];

const String updateDbName = "new_quotes.db";
const String tempDbName = "temp_quotes.db";
const String assetesDbPath = "assets/database/$updateDbName";
