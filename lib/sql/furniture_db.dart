import 'package:furniture_flutter_app/models/FurnitureModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/CartModel.dart';

class FurnitureDatabase {
  static const _databaseName = "cart.db";
  static const _databaseVersion = 1;

  static const table = "cartTable";
  static const columnID = "id";
  static const columnImage = "image";
  static const columnTitle = "title";
  static const columnDescription = "description";
  static const columnReviews = "reviews";
  static const columnFurnitureID = "furnitureID";
  static const columnPrice = "price";
  static const columnItemTotalPrice = "totalPrice";
  static const columnTotalQuantity = "quantity";
  static const columnCategory = "category";

   FurnitureDatabase._privateConstructor();
   static final FurnitureDatabase instance = FurnitureDatabase._privateConstructor();

   static Database? _database;
   Future<Database> getDatabase() async {
    if (_database != null) return _database!;
    _database = await _init();
    return _database!;
  }
   Future<Database> _init() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: (db, version) async {
       await db.execute('''
        CREATE TABLE $table (
          $columnID INTEGER PRIMARY KEY AUTOINCREMENT,
          $columnImage TEXT NOT NULL,
          $columnTitle TEXT NOT NULL,
          $columnDescription TEXT NOT NULL,
          $columnReviews TEXT NOT NULL,
          $columnFurnitureID TEXT NOT NULL,
          $columnPrice DOUBLE NOT NULL,
          $columnItemTotalPrice DOUBLE NOT NULL,
          $columnTotalQuantity INTEGER NOT NULL,
          $columnCategory TEXT NOT NULL)
      ''');
    });
  }
   Future<List<Map<String, Object?>>?> getCartItem() async {
      final db = await getDatabase();
      return  await db.query(table);
   }
   Future<int?> createCartItem(CartModel cartModel) async {
      final db = await getDatabase();
      return await db.insert(table,cartModel.toJson());
   }
   Future<int?> deleteCartItem(CartModel cartModel) async {
      final db = await getDatabase();
      return await db.delete(table, where: 'furnitureID = ?', whereArgs: [cartModel.furnitureID],);
   }
   Future<int?> deleteAllItems() async {
     var db = await getDatabase();
     return await db.delete(table);
   }
   Future<int> updateItem(String rowID,int quantity,double total) async {
     Map<String, Object> data = <String, Object>{};
     data[columnItemTotalPrice] = total;
     data[columnTotalQuantity] = quantity;
     var db = await getDatabase();
     return await db.update(
         table,
         data,
         where: '$columnFurnitureID = ?',
         whereArgs: [rowID]);
   }
  Future<double> getAllItemsDue() async {
    var db = await getDatabase();
    List<Map<String, Object?>> result = await db.rawQuery("SELECT SUM($columnItemTotalPrice) as total FROM $table");

    if (result.isNotEmpty && result.first['total'] != null) {
      return result.first['total'] as double;
    } else {
      return 0.0;
    }
  }
}