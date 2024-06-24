class CartModel {
  static const columnImage = "image";
  static const columnTitle = "title";
  static const columnDescription = "description";
  static const columnReviews = "reviews";
  static const columnFurnitureID = "furnitureID";
  static const columnPrice = "price";
  static const columnItemTotalPrice = "totalPrice";
  static const columnTotalQuantity = "quantity";
  static const columnCategory = "category";

  final String image;
  final String title;
  final String description;
  final String reviews;
  final String furnitureID;
  final double price;
  final double totalPrice;
  final int quantity;
  final String category;


  CartModel({
    required this.image,
    required this.title,
    required this.description,
    required this.reviews,
    required this.furnitureID,
    required this.price,
    required this.totalPrice,
    required this.quantity,
    required this.category,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      image: json[columnImage],
      title: json[columnTitle],
      description: json[columnDescription],
      reviews: json[columnReviews],
      furnitureID: json[columnFurnitureID],
      price: json[columnPrice],
      totalPrice: json[columnItemTotalPrice],
      quantity: json[columnTotalQuantity],
      category: json[columnCategory],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      columnImage: image,
      columnTitle: title,
      columnDescription: description,
      columnReviews: reviews,
      columnFurnitureID: furnitureID,
      columnPrice: price,
      columnItemTotalPrice: totalPrice,
      columnTotalQuantity: quantity,
      columnCategory: category,
    };
  }
}