

import 'package:furniture_flutter_app/main.dart';
import 'package:furniture_flutter_app/models/CartModel.dart';

class CartService {

  Future<List<Map<String, Object?>>?> getCartItem() async {
    return await furnitureDatabase.getCartItem();
  }
  Future<int?> createCartItem(CartModel cartModel) async {
    return await furnitureDatabase.createCartItem(cartModel);
  }
  Future<int?> deleteCartItem(CartModel cartModel) async {
    return await furnitureDatabase.deleteCartItem(cartModel);
  }
  Future<int?> deleteAllItems() async {
     return await furnitureDatabase.deleteAllItems();
  }
  Future<int> updateItem(String rowID,int quantity,double total) async {
     return await furnitureDatabase.updateItem(rowID,quantity, total);
  }
  Future<double> getAllItemsDue() async {
     return await furnitureDatabase.getAllItemsDue();
  }


}