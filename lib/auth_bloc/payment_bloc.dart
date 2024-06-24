

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_flutter_app/auth/cart_service.dart';
import 'package:furniture_flutter_app/auth/firebase_auth.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_event.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_state.dart';
import 'package:furniture_flutter_app/models/CartModel.dart';
import '../models/FurnitureModel.dart';


class PaymentBloc extends Bloc<ShopBlocEvent,ShopBlocState> {
  FurnitureModel? furnitureModel = FurnitureModel();
  final List<FurnitureModel> _furnitureList = [];
  CartService cartService;
  FirebaseAuthService firebaseService;
  PaymentBloc(this.cartService,this.firebaseService) : super(INITIAL()){
    on<GetCartItemsEvent>((event, emit) => _getCartItems(event, emit));
    on<GetCreateItemEvent>((event, emit) => _createItem(event, emit));
    on<GetDeleteItemEvent>((event, emit) => _deleteItem(event, emit));
    on<GetDeleteCartEvent>((event, emit) => _deleteCart(event, emit));
    on<GetUpdateItemEvent>((event, emit) => _updateItem(event, emit));
    on<GetDuesEvent>((event, emit) => _getDues(event, emit));
  }

   _getCartItems(GetCartItemsEvent event,Emitter<ShopBlocState> emit) async {
      try {
        emit(LOADING());
        var items  = await cartService.getCartItem();
        List<CartModel>? list = items?.map((e) => CartModel.fromJson(e)).toList();
        if(list != null && list.isNotEmpty){
          emit(GetCartItemsState(list));
        } else {
          emit(ERROR("No Items In The Cart"));
        }
      } catch(e){
        emit(ERROR(e.toString()));
      }
   }
   _createItem(GetCreateItemEvent event , Emitter<ShopBlocState> emit) async {
       int? result = await cartService.createCartItem(event.cartModel);
       if(result != -1){
         emit(GetCreateItemState("Item Successfully Added"));
       } else {
         emit(GetCreateItemState("Failed to add item in the cart"));
       }
   }
   _deleteItem(GetDeleteItemEvent event, Emitter<ShopBlocState> emit) async {
        int? result = await cartService.deleteCartItem(event.cartModel);
        if(result == 1){
           emit(GetDeleteItemState("Item Successfully Deleted"));
        } else {
           emit(GetDeleteItemState("Failed to delete item"));
        }
   }
   _deleteCart(GetDeleteCartEvent event,Emitter<ShopBlocState> emit) async {
       int? result = await cartService.deleteAllItems();
       if(result! > 1){
          emit(GetDeleteCartState("Items Successfully cleared"));
       } else {
          emit(GetDeleteCartState("Failed to clear cart"));
       }
   }
   _updateItem(GetUpdateItemEvent event,Emitter<ShopBlocState> emit) async {
         int result = await cartService.updateItem(event.rowID,event.quantity, event.total);
         if(result != -1){
            emit(GetUpdateItemState("Item Successfully Updated"));
         } else {
            emit(GetUpdateItemState("Could not update item"));
         }
   }
   _getDues(GetDuesEvent event,Emitter<ShopBlocState> emit) async {
    double all = 0.0;
    var items = await cartService.getCartItem();
    List<CartModel>? result = items?.map((e) => CartModel.fromJson(e)).toList();
    result?.forEach((element) {
      all = all + element.totalPrice;
    });
    emit(GetDuesState(all));

  }
  }