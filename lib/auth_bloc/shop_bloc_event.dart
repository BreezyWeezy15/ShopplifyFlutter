
import 'dart:io';

import 'package:furniture_flutter_app/models/CartModel.dart';
import 'package:furniture_flutter_app/models/FurnitureModel.dart';

abstract class ShopBlocEvent {}
class LoginUserEvent extends ShopBlocEvent {
   String email;
   String password;
   LoginUserEvent(this.email,this.password);
}
class RegisterUserEvent extends ShopBlocEvent {
  String userImage;
  String name;
  String email;
  String password;
  String phone;

  RegisterUserEvent(this.userImage,this.name,this.email,this.password,this.phone);
}
class UploadDataEvent extends ShopBlocEvent {
  String userImage;
  String name;
  String email;
  String phone;

  UploadDataEvent(this.userImage,this.name,this.email,this.phone);
}
class LogoutEvent extends ShopBlocEvent {}
class DeleteAccountEvent extends ShopBlocEvent {}
class RecoverPassEvent extends ShopBlocEvent {
  String email;
  RecoverPassEvent(this.email);
}
class UserStatusEvent extends ShopBlocEvent {}
class GetUserDataEvent extends ShopBlocEvent {}
class GetUploadUserImageEvent extends ShopBlocEvent {
  File? file;
  String email;
  String name;
  String phone;
  GetUploadUserImageEvent(this.file,this.email,this.name,this.phone);
}
class UploadFavItemEvent extends ShopBlocEvent {
   FurnitureModel? furnitureModel;
   UploadFavItemEvent(this.furnitureModel);
}
class GetUserFavItemsEvent extends ShopBlocEvent {}
class GeRemoveItemEvent extends ShopBlocEvent {
  String itemID;
  GeRemoveItemEvent(this.itemID);
}



// GET PRODUCTS
class GetFurnitureEvent extends ShopBlocEvent {
   String category;
   GetFurnitureEvent(this.category);
}
class SearchFurnitureEvent extends ShopBlocEvent {
  String value;
  SearchFurnitureEvent(this.value);
}
class GetItemEvent extends ShopBlocEvent {
   String itemID;
   GetItemEvent(this.itemID);
}

// CART ITEMS
class GetCartItemsEvent extends ShopBlocEvent {

}
class GetCreateItemEvent extends ShopBlocEvent {
    CartModel cartModel;
    GetCreateItemEvent(this.cartModel);
}
class GetDeleteItemEvent extends ShopBlocEvent {
   CartModel cartModel;
   GetDeleteItemEvent(this.cartModel);
}
class GetDeleteCartEvent extends ShopBlocEvent {}
class GetUpdateItemEvent extends ShopBlocEvent {
  String rowID;
  int quantity;
  double total;
  GetUpdateItemEvent(this.rowID,this.quantity,this.total);
}
class GetDuesEvent extends ShopBlocEvent {

}