

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_event.dart';
import 'package:furniture_flutter_app/auth_bloc/shop_bloc_state.dart';
import 'package:furniture_flutter_app/models/UserModel.dart';

import '../auth/firebase_auth.dart';
import '../models/FurnitureModel.dart';

class ShopBloc extends Bloc<ShopBlocEvent,ShopBlocState> {
  FurnitureModel? furnitureModel = FurnitureModel();
  final List<FurnitureModel> _furnitureList = [];
  FirebaseAuthService firebaseAuthService;
  ShopBloc(this.firebaseAuthService) : super(INITIAL()){
       on<LoginUserEvent>((event, emit) => _loginUser(event, emit));
       on<RegisterUserEvent>((event, emit) => _registerUser(event, emit));
       on<UploadDataEvent>((event, emit) => _uploadUserData(event, emit));
       on<DeleteAccountEvent>((event, emit) => _deleteUserAccount(event, emit));
       on<RecoverPassEvent>((event, emit) => _recoverUserPassword(event, emit));
       on<UserStatusEvent>((event, emit) => _checkUserStatus(event, emit));
       on<GetUserDataEvent>((event, emit) => _getUserData(event, emit));
       on<GetFurnitureEvent>((event, emit) => _getFurniture(event, emit));
       on<GetUploadUserImageEvent>((event, emit) => _uploadUserImage(event, emit));
       on<LogoutEvent>((event, emit) => _logoutUser(event, emit));
  }

  _loginUser(LoginUserEvent event,Emitter<ShopBlocState> emit) async {
    emit(LOADING());
     try {
       UserCredential? userCredential = await firebaseAuthService.loginUser(event.email,event.password);
       if(userCredential != null){
         emit(LoginState(userCredential));
       } else {
         emit(ERROR("Failed to login user"));
       }
     } catch(e){
       emit(ERROR(e.toString()));
     }
  }
  _registerUser(RegisterUserEvent event,Emitter<ShopBlocState> emit) async {
    emit(LOADING());
    try {
      UserCredential? userCredential = await firebaseAuthService.registerUser(event.email,event.password);
      if(userCredential != null){
        emit(RegisterState(userCredential,event.userImage, event.name,event.email,event.phone));
      } else {
        emit(ERROR("Failed to login user"));
      }
    } catch(e){
      emit(ERROR(e.toString()));
    }
  }
  _logoutUser(LogoutEvent event,Emitter<ShopBlocState> emit) async {
      try {
         await firebaseAuthService.logout();
         emit(LogoutState(true));
      } catch(e){
        emit(LogoutState(false));
      }
  }
  _uploadUserData(UploadDataEvent event,Emitter<ShopBlocState> emit) async {
     try {
       await firebaseAuthService.uploadUserData(event.userImage,event.name, event.email, event.phone);
       emit(UploadDataState(true));
     } catch(e){
       emit(ERROR(e.toString()));
     }
  }
  _deleteUserAccount(DeleteAccountEvent event,Emitter<ShopBlocState> emit) async {
     try {
       await firebaseAuthService.deleteUserAccount();
       emit(DeleteAccountState(true));
     } catch(e){
       emit(DeleteAccountState(false));
     }
  }
  _recoverUserPassword(RecoverPassEvent event,Emitter<ShopBlocState> emit) async {
     try {
       await firebaseAuthService.recoverPassword(event.email);
       emit(RecoverPassState(true));
     } catch(e){
       emit(RecoverPassState(false));
     }
  }
  _checkUserStatus(UserStatusEvent event,Emitter<ShopBlocState> emit) async {
     bool isSignedIn =  firebaseAuthService.isUserSignedIn();
     if(isSignedIn){
       emit(UserStatusState(true));
     } else {
       emit(UserStatusState(false));
     }
  }
  _getUserData(GetUserDataEvent event,Emitter<ShopBlocState> emit) async {
      DataSnapshot dataSnapshot = await firebaseAuthService.getUserData();
      if(dataSnapshot.exists){
          var data = dataSnapshot.value as Map<Object?, Object?>;
          UserModel userModel = _createUserModel(data);
          emit(GetUserDataState(userModel));
      }
  }
  _getFurniture(GetFurnitureEvent event,Emitter<ShopBlocState> emit) async {
    emit(LOADING());
    try {
      DataSnapshot dataSnapshot = await firebaseAuthService.getFurniture();
      if(dataSnapshot.exists){
        print("Bloc 1");
        _furnitureList.clear();
        for(var v in dataSnapshot.children){
          print("Bloc 2");
          var furnitureMap = v.value as Map<Object?, Object?>;
          if(event.category == "All"){
            furnitureModel = _createFurnitureModel(furnitureMap);
            _furnitureList.add(furnitureModel!);
          }
          else if(furnitureMap["category"] == event.category){
            furnitureModel = _createFurnitureModel(furnitureMap);
            _furnitureList.add(furnitureModel!);
          }
        }
        emit(GetFurnitureState(_furnitureList));
      } else {
        print("Bloc 3");
        emit(ERROR("No furniture found"));
      }
    } catch (e) {
      print("Bloc 4");
      emit(ERROR(e.toString()));
    }
  }
  _uploadUserImage(GetUploadUserImageEvent event,Emitter<ShopBlocState> emit) async {
      String? downloadUrl = await firebaseAuthService.updateUserPic(event.file,event.email,event.name,event.phone);
      emit(GetUploadUserImageState(downloadUrl,event.name,event.email,event.phone));
  }


  _createUserModel(Map<Object?, Object?> data){
    return UserModel(
        email: data["email"].toString(),
        name: data["name"].toString(),
        phone: data["phone"].toString(),
        uid: data["uid"].toString(),
        userImage: data["userImage"].toString());
  }
  _createFurnitureModel(Map<Object?, Object?> furnitureMap){
    return FurnitureModel(
        description: furnitureMap["description"].toString(),
        id: furnitureMap["id"].toString(),
        image: furnitureMap["image"].toString(),
        price: double.tryParse(furnitureMap["price"].toString()),
        reviews: furnitureMap["reviews"].toString(),
        title: furnitureMap["title"].toString(),
        category: furnitureMap["category"].toString()
    );
  }


}