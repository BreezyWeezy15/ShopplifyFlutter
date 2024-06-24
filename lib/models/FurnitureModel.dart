import 'dart:ffi';

/// description : "Small USB Plug Lamp LED Night Light Computer Mobile Power Charging Mini Book Lamps LED Eye Protection Square Reading Light"
/// id : "xxx-2"
/// image : "https://firebasestorage.googleapis.com/v0/b/shoplify-8a6b4.appspot.com/o/images%2Fimage1.PNG?alt=media&token=ab099900-1ff5-4c06-a378-da3bb6047963"
/// price : "35.50$"
/// reviews : "5/10"
/// category : "Chair"
/// title : "Small USB Plug Lamp LED Night Light Computer Mobile Power Charging Mini Book Lamps LED Eye Protection Square Reading Light"

class FurnitureModel {
  FurnitureModel({
      String? description, 
      String? id, 
      String? image, 
      double? price, 
      String? reviews, 
      String? category, 
      String? title,}){
    _description = description;
    _id = id;
    _image = image;
    _price = price;
    _reviews = reviews;
    _category = category;
    _title = title;
}

  FurnitureModel.fromJson(dynamic json) {
    _description = json['description'];
    _id = json['id'];
    _image = json['image'];
    _price = json['price'];
    _reviews = json['reviews'];
    _category = json['category'];
    _title = json['title'];
  }
  String? _description;
  String? _id;
  String? _image;
  double? _price;
  String? _reviews;
  String? _category;
  String? _title;
FurnitureModel copyWith({  String? description,
  String? id,
  String? image,
  double? price,
  String? reviews,
  String? category,
  String? title,
}) => FurnitureModel(  description: description ?? _description,
  id: id ?? _id,
  image: image ?? _image,
  price: price ?? _price,
  reviews: reviews ?? _reviews,
  category: category ?? _category,
  title: title ?? _title,
);
  String? get description => _description;
  String? get id => _id;
  String? get image => _image;
  double? get price => _price;
  String? get reviews => _reviews;
  String? get category => _category;
  String? get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['description'] = _description;
    map['id'] = _id;
    map['image'] = _image;
    map['price'] = _price;
    map['reviews'] = _reviews;
    map['category'] = _category;
    map['title'] = _title;
    return map;
  }

}