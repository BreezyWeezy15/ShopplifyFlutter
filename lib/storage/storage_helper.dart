
import 'package:get_storage/get_storage.dart';

class StorageHelper {
   static final _box = GetStorage();

   static void saveInfo(String name,String email,String phone){
       _box.write("name", name);
       _box.write("email", email);
       _box.write("phone", phone);
   }
   static String getName() {
      return _box.read("name");
   }
   static String getEmail() {
      return _box.read("email");
   }
   static String getPhone(){
      return _box.read("phone");
   }
   static setPosition(int position){
       _box.write("position", position);
   }
   static int getPosition() {
      return _box.read("position") ?? 0;
   }

}