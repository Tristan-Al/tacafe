import 'dart:convert';

class Product {
  String? id;
  String category;
  String description;
  String? image;
  String name;
  double price;
  int stock;

  Product({
    this.id,
    required this.category,
    required this.description,
    this.image,
    required this.name,
    required this.price,
    required this.stock,
  });

  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Product.fromMap(Map<String, dynamic> json) => Product(
        category: json["category"],
        description: json["description"],
        image: json["image"],
        name: json["name"],
        price: json["price"]?.toDouble(),
        stock: json["stock"],
      );

  Map<String, dynamic> toMap() => {
        "category": category,
        "description": description,
        "image": image,
        "name": name,
        "price": price,
        "stock": stock,
      };

  @override
  String toString() {
    return 'Product{ id: $id, name: $name, ';
  }
}
