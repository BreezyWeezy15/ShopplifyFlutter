

import 'package:firebase_auth/firebase_auth.dart';
import 'package:furniture_flutter_app/models/UserModel.dart';

import '../models/CartModel.dart';
import '../models/FurnitureModel.dart';

abstract class ShopBlocState {}

class INITIAL extends ShopBlocState {}
class LOADING extends ShopBlocState {}
class ERROR extends ShopBlocState {
   String e;
   ERROR(this.e);
}
class LoginState extends ShopBlocState {
    UserCredential? userCredential;
    LoginState(this.userCredential);
}
class RegisterState extends ShopBlocState {
   UserCredential? userCredential;
   String userImage;
   String name;
   String email;
   String phone;
   RegisterState(this.userCredential,this.userImage,this.name,this.email,this.phone);
}
class UploadDataState extends ShopBlocState {
   bool isSuccess = false;
   UploadDataState(this.isSuccess);
}

class LogoutState extends ShopBlocState {
    bool isSuccess;
    LogoutState(this.isSuccess);
}

class DeleteAccountState extends ShopBlocState{
   bool isDeleted;
   DeleteAccountState(this.isDeleted);
}
class RecoverPassState extends ShopBlocState {
   bool isSuccess;
   RecoverPassState(this.isSuccess);
}
class UserStatusState extends ShopBlocState {
    bool isSignedIn;
    UserStatusState(this.isSignedIn);
}
class GetUserDataState extends ShopBlocState {
   UserModel userModel;
   GetUserDataState(this.userModel);
}
class GetUploadUserImageState extends ShopBlocState {
   String? downloadUrl;
   String email;
   String name;
   String phone;
   GetUploadUserImageState(this.downloadUrl,this.email,this.name,this.phone);
}

/// GET FURNITURE
class GetFurnitureState extends ShopBlocState {
    List<FurnitureModel?> furniture;
    GetFurnitureState(this.furniture);
}
class SearchFurnitureState extends ShopBlocState {
  List<FurnitureModel?> furniture;
  SearchFurnitureState(this.furniture);
}
class GetItemState extends ShopBlocState {
    FurnitureModel? furnitureModel;
    GetItemState(this.furnitureModel);
}
class UploadFavItemState extends ShopBlocState {
  String message;
  UploadFavItemState(this.message);
}
class GetUserFavItemsState extends ShopBlocState {
  List<FurnitureModel?>  list;
  GetUserFavItemsState(this.list);
}
class GetRemoveItemState extends ShopBlocState {
  String message;
  GetRemoveItemState(this.message);
}

// GET CART
class GetCartItemsState extends ShopBlocState {
   List<CartModel> list;
   GetCartItemsState(this.list);
}
class GetCreateItemState extends ShopBlocState {
   String result;
   GetCreateItemState(this.result);
}
class GetDeleteItemState extends ShopBlocState {
   String result;
   GetDeleteItemState(this.result);
}
class GetDeleteCartState extends ShopBlocState {
    String result;
    GetDeleteCartState(this.result);
}
class GetUpdateItemState extends ShopBlocState {
   String result;
   GetUpdateItemState(this.result);
}
class GetDuesState extends ShopBlocState {
   double total;
   GetDuesState(this.total);
}

