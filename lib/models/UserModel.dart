/// email : "youtube@gmail.com"
/// name : "youtube"
/// phone : "+213777523687"
/// uid : "IGFRuxD08LPfNZmCXSKOEW34rZD3"
/// userImage : "https://firebasestorage.googleapis.com/v0/b/shoplify-8a6b4.appspot.com/o/profile.png?alt=media&token=56a894db-c322-47e7-be83-81ed7f421873"

class UserModel {
  UserModel({
      String? email, 
      String? name, 
      String? phone, 
      String? uid, 
      String? userImage,}){
    _email = email;
    _name = name;
    _phone = phone;
    _uid = uid;
    _userImage = userImage;
}

  UserModel.fromJson(dynamic json) {
    _email = json['email'];
    _name = json['name'];
    _phone = json['phone'];
    _uid = json['uid'];
    _userImage = json['userImage'];
  }
  String? _email;
  String? _name;
  String? _phone;
  String? _uid;
  String? _userImage;
UserModel copyWith({  String? email,
  String? name,
  String? phone,
  String? uid,
  String? userImage,
}) => UserModel(  email: email ?? _email,
  name: name ?? _name,
  phone: phone ?? _phone,
  uid: uid ?? _uid,
  userImage: userImage ?? _userImage,
);
  String? get email => _email;
  String? get name => _name;
  String? get phone => _phone;
  String? get uid => _uid;
  String? get userImage => _userImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['name'] = _name;
    map['phone'] = _phone;
    map['uid'] = _uid;
    map['userImage'] = _userImage;
    return map;
  }

}