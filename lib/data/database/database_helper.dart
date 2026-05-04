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

  Future<void> _insertSeedData(Database db) async {
    final now = DateTime.now();
    final seeds = [
      {
        'title': '50% OFF en Pizza',
        'descripcion':
            'Disfruta la mitad de precio en cualquier pizza grande de la carta. Válido para delivery',
        'percentage': 50.0,
        'category_id': 'food',
        'store_name': 'PizzaHot',
        'image_url': null,
        'coupon_code': 'PIZZA50',
        'expiration_date': now.add(const Duration(days: 15)).toIso8601String(),
        'is_favorite': 0,
        'created_at': now.toIso8601String(),
      },
      {
        'title': '20% en Cine y Streaming',
        'description': 
          'Dos meses de suscripción premium con descuento exclusivo para nuevos usuarios.',
        'percentage': 20.0,
        'category_id': 'entertainment',
        'store_name': 'CineMax',
        'image_url': null,
        'coupon_code': 'CINE20',
        'expiration_date': now.add(const Duration(days: 25)).toIso8601String(),
        'is_favorite': 0,
        'created_at': now.subtract(const Duration(days: 5)).toIso8601String(),
      },
      {

        'title': '30% en Auriculares Sony',
        'description':
            'Aprovecha este descuento increíble en los mejores auriculares inalámbricos del mercado.',
        'percentage': 30.0,
        'category_id': 'tech',
        'store_name': 'TechStore',
        'image_url': null,
        'coupon_code': 'SONY30',
        'expiration_date': now.add(const Duration(days: 7)).toIso8601String(),
        'is_favorite': 1,
        'created_at': now.subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'title': '40% en Ropa de Verano',
        'description':
            'Toda la colección de verano con descuento. Camisetas, shorts, vestidos y más.',
        'percentage': 40.0,
        'category_id': 'fashion',
        'store_name': 'FashionWorld',
        'image_url': null,
        'coupon_code': 'SUMMER40',
        'expiration_date': now.add(const Duration(days: 30)).toIso8601String(),
        'is_favorite': 0,
        'created_at': now.subtract(const Duration(days: 2)).toIso8601String(),
      },
      {
        'title': '25% en Vuelos Nacionales',
        'description':
            'Reserva tu vuelo con anticipación y ahorra 25% en cualquier destino nacional.',
        'percentage': 25.0,
        'category_id': 'travel',
        'store_name': 'AeroViajes',
        'image_url': null,
        'coupon_code': 'VUELO25',
        'expiration_date': now.add(const Duration(days: 20)).toIso8601String(),
        'is_favorite': 1,
        'created_at': now.subtract(const Duration(days: 3)).toIso8601String(),
      },
      {
        'title': '35% en Equipamiento Deportivo',
        'description':
            'Todo lo que necesitas para tu deporte favorito con un gran descuento.',
        'percentage': 35.0,
        'category_id': 'sports',
        'store_name': 'SportMax',
        'image_url': null,
        'coupon_code': 'SPORT35',
        'expiration_date': now.add(const Duration(days: 10)).toIso8601String(),
        'is_favorite': 0,
        'created_at': now.subtract(const Duration(days: 4)).toIso8601String(),
      },
      {
        'title': '20% en Cine y Streaming',
        'description':
            'Dos meses de suscripción premium con descuento exclusivo para nuevos usuarios.',
        'percentage': 20.0,
        'category_id': 'entertainment',
        'store_name': 'CineMax',
        'image_url': null,
        'coupon_code': 'CINE20',
        'expiration_date': now.add(const Duration(days: 25)).toIso8601String(),
        'is_favorite': 0,
        'created_at': now.subtract(const Duration(days: 5)).toIso8601String(),
      },
    ];
    for (final seed in seeds) {
      await db.insert(tableDiscounts, seed);
    }
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  
  }
}
