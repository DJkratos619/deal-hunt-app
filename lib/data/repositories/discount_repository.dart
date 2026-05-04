import 'package:app_descuento_virtual/data/database/database_helper.dart';
import 'package:app_descuento_virtual/data/models/discount.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class IDiscountRepository {
  Future<List<Discount>> getAll();
  Future<Discount?> getById(int id);
  Future<int> insert(Discount discount);
  Future<int> update(Discount discount);
  Future<int> delete(int id);
  Future<List<Discount>> getFavorites();
  Future<List<Discount>> getByCategory(String categoryId);
  Future<List<Discount>> search(String query);
  Future<int> toggleFavorite(int id, bool isFavorite);
}

//SQLlite Implementation
class DiscountRepository implements IDiscountRepository {
  final DatabaseHelper _dbHelper;

  DiscountRepository({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper();

  Future<Database> get _db async => _dbHelper.database;

  @override
Future<int> delete(int id) async {
  final db = await _db;
  return db.delete(
    DatabaseHelper.tableDiscounts,
    where: '${DatabaseHelper.colId} = ?',
    whereArgs: [id]
  );
}

  @override
  Future<List<Discount>> getAll() async {
    final db = await _db;
    final maps = await db.query(
      DatabaseHelper.tableDiscounts,
      orderBy: '${DatabaseHelper.colCreateAt} DESC',
    );
    return maps.map(Discount.fromMap).toList();
  }

  @override
Future<List<Discount>> getByCategory(String categoryId) async {
  if (categoryId == 'all') return getAll();
  final db = await _db;
  final maps = await db.query(
    DatabaseHelper.tableDiscounts,
    where: '${DatabaseHelper.colCategoryId} = ?',
    whereArgs: [categoryId],
    orderBy: '${DatabaseHelper.colCreateAt} DESC'
  );

  return maps.map(Discount.fromMap).toList();
}

  @override
  Future<Discount?> getById(int id) async {
    final db = await _db;
    final maps = await db.query(
      DatabaseHelper.tableDiscounts,
      where: '${DatabaseHelper.colId} = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return Discount.fromMap(maps.first);
  }

    @override
Future<List<Discount>> getFavorites() async {
  final db = await _db;
  final maps = await db.query(
    DatabaseHelper.tableDiscounts,
    where: '${DatabaseHelper.colIsFavorite} = ?',
    whereArgs: [1],
    orderBy: '${DatabaseHelper.colCreateAt} DESC'
  );

  return maps.map(Discount.fromMap).toList();
}

    @override
  Future<int> insert(Discount discount) async {
    final db = await _db;
    return await db.insert(
      DatabaseHelper.tableDiscounts,
      discount.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

    @override
Future<List<Discount>> search(String query) async {
  final db = await _db;
  final likeQuery = '%$query%';
  final maps = await db.query(
    DatabaseHelper.tableDiscounts,
    where:
        '${DatabaseHelper.colTitle} LIKE ? OR ${DatabaseHelper.colStoreName} LIKE ? OR ${DatabaseHelper.colDescription} LIKE ?',
    whereArgs: [likeQuery, likeQuery, likeQuery],
    orderBy: '${DatabaseHelper.colCreateAt} DESC',
  );

  return maps.map(Discount.fromMap).toList();
}

    @override
Future<int> toggleFavorite(int id, bool isFavorite) async {
  final db = await _db;
  return await db.update(
    DatabaseHelper.tableDiscounts,
    {DatabaseHelper.colIsFavorite: isFavorite ? 1 : 0},
    where: '${DatabaseHelper.colId} = ?',
    whereArgs: [id]
  );
}

    @override
  Future<int> update(Discount discount) async {
    final db = await _db;
    return await db.update(
      DatabaseHelper.tableDiscounts,
      discount.toMap(),
      where: '${DatabaseHelper.colId} = ?',
      whereArgs: [discount.id],
    );
  }
  }

