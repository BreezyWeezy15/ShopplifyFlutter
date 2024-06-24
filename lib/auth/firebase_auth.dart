import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:furniture_flutter_app/models/FurnitureModel.dart';

class FirebaseAuthService {

    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;
    final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

    Future<UserCredential?> loginUser(String email,String password) async {
       return await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    }
    Future<UserCredential?> registerUser(String email, String password) async {
       return await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    }
    Future uploadUserData(String userImage,String name,String email,String phone) async {
        final Map<String, Object> userData = {
            "name": name,
            "email": email,
            "phone": phone,
            "userImage": userImage,
            "uid": _firebaseAuth.currentUser!.uid
        };

        await _firebaseDatabase.ref().child("Users")
            .child(_firebaseAuth.currentUser!.uid)
            .update(userData);
    }
    Future deleteUserAccount() async {
        return await _firebaseAuth.currentUser?.delete();
    }
    Future logout() async {
        return await _firebaseAuth.signOut();
    }
    Future recoverPassword(String email) async {
        return await _firebaseAuth.sendPasswordResetEmail(email: email);
    }
    bool isUserSignedIn()  {
        return _firebaseAuth.currentUser != null ? true : false;
    }
    Future<DataSnapshot> getUserData() async {
        return await _firebaseDatabase.ref().child("Users").child(_firebaseAuth.currentUser!.uid).get();
    }
    Future<String?> updateUserPic(File? file,String email,String name,String phone) async {
         var ref = _firebaseStorage.ref().child("Images").child(_firebaseAuth.currentUser!.uid);
         UploadTask uploadTask =  ref.putFile(file!);
         var snapShot =  await uploadTask.whenComplete((){});
         return await snapShot.ref.getDownloadURL();
    }
    Future uploadUserFavItem(FurnitureModel furnitureModel) async {
        return await _firebaseDatabase.ref().child("Favs")
            .child(_firebaseAuth.currentUser!.uid)
            .child(furnitureModel.id!)
            .set(furnitureModel.toJson());
    }
    Future<DataSnapshot> getUserFavItems() async {
        return await _firebaseDatabase.ref().child("Favs")
            .child(_firebaseAuth.currentUser!.uid)
            .get();
    }
    Future removeItem(String itemID) async {
        return await _firebaseDatabase.ref().child("Favs")
            .child(_firebaseAuth.currentUser!.uid)
            .child(itemID)
            .remove();
    }

    /// GET PRODUCTS
    Future<DataSnapshot> getFurniture() async {
       return await _firebaseDatabase.ref().child("Products").get();
    }
    Future<DataSnapshot> searchFurniture()  async {
        return await _firebaseDatabase.ref().child("Products").get();
    }
    Future<DataSnapshot> getItem(String itemID) async {
        return await _firebaseDatabase.ref().child("Products").child(itemID).get();
    }

}