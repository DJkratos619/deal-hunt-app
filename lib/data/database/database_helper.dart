import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;
  static const String _dbName = 'deal_hunt.db';
  static const int _dbVersion = 1;

  static const String tableDiscounts = 'discounts';
  static const String colId = 'id';
  static const String colTitle = 'title';
  static const String colDescription = 'description';
  static const String colPercentage = 'percentage';
  static const String colCategoryId = 'category_id';
  static const String colStoreName = 'store_name';
  static const String colImageUrl = 'image_url';
  static const String colCouponCode = 'coupon_code';
  static const String colExpirationDate = 'expiration_date';
  static const String colIsFavorite = 'is_favorite';
  static const String colCreateAt = 'created_at';

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE $tableDiscounts('
      '$colId INTEGER PRIMARY KEY AUTOINCREMENT,'
      '$colTitle TEXT NOT NULL,'
      '$colDescription TEXT NOT NULL,'
      '$colPercentage REAL NOT NULL,'
      '$colCategoryId TEXT NOT NULL,'
      '$colStoreName TEXT NOT NULL,'
      '$colImageUrl TEXT,'
      '$colCouponCode TEXT DEFAULT "",'
      '$colExpirationDate TEXT NOT NULL,'
      '$colIsFavorite INTEGER DEFAULT 0,'
      '$colCreateAt TEXT NOT NULL'
      ')',
    );
    await _insertSeedData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // handle future migrations here
  }

  Future<void> _insertSeedData(Database db) async {}
}
