import 'dart:convert';

import 'package:emigo/models/product_model.dart';


class OrderModel {
  final String id;
  final List<ProductModel> products;
  final List<int> quantity;
  final String address;
  final String userId;
  final String receiverName;
  final String receiverPhone;
  final String paymentMethod;
  final int orderedAt;
  final int status;
  final String description;
  final String voucherCode;
  final double totalPrice;
  final double initialPrice;
  OrderModel({
    required this.id,
    required this.products,
    required this.quantity,
    required this.address,
    required this.userId,
    required this.receiverName,
    required this.receiverPhone,
    required this.paymentMethod,
    required this.orderedAt,
    required this.status,
    required this.description,
    required this.voucherCode,
    required this.totalPrice,
    required this.initialPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'products': products.map((x) => x.toMap()).toList(),
      'quantity': quantity,
      'address': address,
      'userId': userId,
      'receiverName': receiverName,
      'receiverPhone': receiverPhone,
      'paymentMethod': paymentMethod,
      'orderedAt': orderedAt,
      'status': status,
      'description': description,
      'voucherCode': voucherCode,
      'totalPrice': totalPrice,
      'initialPrice': initialPrice,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['_id'] ?? '',
      products: List<ProductModel>.from(
          map['products']?.map((x) => ProductModel.fromMap(x['product']))),
      quantity: List<int>.from(
        map['products']?.map(
          (x) => x['quantity'],
        ),
      ),
      address: map['address'] ?? '',
      userId: map['userId'] ?? '',
      receiverName: map['receiverName'] ?? '',
      receiverPhone: map['receiverPhone'] ?? '',
      paymentMethod: map['paymentMethod'] ?? '',
      orderedAt: map['orderedAt']?.toInt() ?? 0,
      status: map['status']?.toInt() ?? 0,
      description: map['description'] ?? '',
      voucherCode: map['voucherId'] ?? '',
      totalPrice: map['totalPrice']?.toDouble() ?? 0.0,
      initialPrice: map['initialPrice']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) => OrderModel.fromMap(json.decode(source));
}
