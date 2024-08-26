import 'dart:convert';
import 'package:emigo/models/rating.dart';

class ProductModel {
  final String name;
  final String description;
  final double quantity;
  final List<String> images;
  final String category;
  final double price;
  final double discountPrice;
  final double sellCount;
  final String? id;
  List<RatingModel> ratings = [];

  ProductModel({
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    required this.discountPrice,
    this.sellCount = 0.0,
    this.id,
    required this.ratings,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'quantity': quantity,
      'images': images,
      'category': category,
      'price': price,
      'discountPrice': discountPrice,
      'sellCount': sellCount,
      'id': id,
      'ratings': ratings.map((x) => x.toMap()).toList(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      quantity: map['quantity']?.toDouble() ?? 0.0,
      images: List<String>.from(map['images']),
      category: map['category'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      discountPrice: map['discountPrice']?.toDouble() ?? 0.0,
      sellCount: map['sellCount']?.toDouble() ?? 0.0,
      id: map['_id'],
      ratings: map['ratings'] != null
          ? List<RatingModel>.from(
        map['ratings']?.map(
              (x) => RatingModel.fromMap(x),
        ),
      )
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source));
}
