
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_flutter_app/auth/cart_service.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_event.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_state.dart';
import 'package:furniture_flutter_app/models/CartModel.dart';
import 'package:furniture_flutter_app/models/FurnitureModel.dart';

import '../auth/firebase_auth.dart';

class FurnitureBloc extends Bloc<ShopBlocEvent,ShopBlocState> {

  FurnitureModel? furnitureModel = FurnitureModel();
  final List<FurnitureModel> _furnitureList = [];
  CartService cartService;
  FirebaseAuthService firebaseAuthService;
  FurnitureBloc(this.firebaseAuthService,this.cartService)  : super(INITIAL()){
    on<SearchFurnitureEvent>((event, emit) => _searchFurniture(event, emit));
    on<GetItemEvent>((event, emit) => _getItem(event, emit));
    on<GetUserFavItemsEvent>((event, emit) => _getUserFavItems(event, emit));
    on<GeRemoveItemEvent>((event, emit) => _removeFavItem(event, emit));
    on<UploadFavItemEvent>((event, emit) => _uploadUserFavItem(event, emit));
  }

  _getUserFavItems(GetUserFavItemsEvent event,Emitter<ShopBlocState> emit) async {
    try {
      emit(LOADING());
      DataSnapshot dataSnapshot = await firebaseAuthService.getUserFavItems();
      if(dataSnapshot.exists){
        _furnitureList.clear();
        for(var shot in dataSnapshot.children){
          var data = shot.value as Map<Object?, Object?>;
          var furnitureModel = FurnitureModel(
              description: data["description"].toString(),
              image:  data["image"].toString(),
              id: data["id"].toString(),
              price: double.parse(data["price"].toString()),
              reviews: data["reviews"].toString(),
              category: data["category"].toString(),
              title: data["title"].toString()
          );
          _furnitureList.add(furnitureModel);
        }
        emit(GetUserFavItemsState(_furnitureList));
      }
      else {
        emit(ERROR("No Fav Items"));
      }
    } catch(e){
      emit(ERROR(e.toString()));
    }
  }
   _searchFurniture(SearchFurnitureEvent event,Emitter<ShopBlocState> emit) async {
     emit(LOADING());
    try {
      DataSnapshot furnitureStream = await firebaseAuthService.searchFurniture();
      if(furnitureStream.exists){
        _furnitureList.clear();
        for(var v in furnitureStream.children){
          var furnitureMap = v.value as Map<Object?, Object?>;
          if(event.value.isEmpty){
            furnitureModel = FurnitureModel(
                description: furnitureMap["description"].toString(),
                id: furnitureMap["id"].toString(),
                image: furnitureMap["image"].toString(),
                price: double.tryParse(furnitureMap["price"].toString()),
                reviews: furnitureMap["reviews"].toString(),
                title: furnitureMap["title"].toString(),
                category: furnitureMap["category"].toString()
            );
            _furnitureList.add(furnitureModel!);
          }
          else if(furnitureMap["title"].toString().toLowerCase().contains(event.value.toLowerCase())){
            furnitureModel = FurnitureModel(
                description: furnitureMap["description"].toString(),
                id: furnitureMap["id"].toString(),
                image: furnitureMap["image"].toString(),
                price: double.tryParse(furnitureMap["price"].toString()),
                reviews: furnitureMap["reviews"].toString(),
                title: furnitureMap["title"].toString(),
                category: furnitureMap["category"].toString()
            );
            _furnitureList.add(furnitureModel!);
          }
          emit(SearchFurnitureState(_furnitureList));
        }
      } else {
        emit(ERROR("No furniture found"));
      }
    } catch (e) {
      emit(ERROR(e.toString()));
    }
  }
   _getItem(GetItemEvent event,Emitter<ShopBlocState> emit) async {
      try {
        emit(LOADING());
        DataSnapshot dataSnapshot = await firebaseAuthService.getItem(event.itemID);
        if(dataSnapshot.exists){
          var furnitureMap = dataSnapshot.value as Map<Object?, Object?>;
          var data = FurnitureModel(
            description: furnitureMap["description"].toString(),
            id: furnitureMap["id"].toString(),
            image: furnitureMap["image"].toString(),
            price: double.tryParse(furnitureMap["price"].toString()),
            reviews: furnitureMap["reviews"].toString(),
            title: furnitureMap["title"].toString(),
            category: furnitureMap["category"].toString(),
          );
          emit(GetItemState(data));
        }
      } catch(e){
        emit(ERROR(e.toString()));
      }
   }
  _removeFavItem(GeRemoveItemEvent event,Emitter<ShopBlocState> emit) async {
    try {
      await firebaseAuthService.removeItem(event.itemID);
      emit(GetRemoveItemState("Successfully Deleted"));
    } catch(e){
      emit(ERROR(e.toString()));
    }
  }
  _uploadUserFavItem(UploadFavItemEvent event , Emitter<ShopBlocState> emit) async {
    try {
      await firebaseAuthService.uploadUserFavItem(event.furnitureModel!);
      emit(UploadFavItemState("Added To Fav"));
    } catch (e) {
      emit(UploadFavItemState("Failed to add to Fav"));
    }
  }

}