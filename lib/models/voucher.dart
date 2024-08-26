import 'dart:convert';

class VoucherModel {
  final  String? id;
  final String code;
  final String description;
  final String discountType;
  final double discountValue;
  final double minOrderValue;
  final double? maxDiscountAmount;
  final DateTime startDate;
  final DateTime endDate;
  final int usageLimit;
  final int usageCount;
  final bool active;

  VoucherModel({
    this.id,
    required this.code,
    required this.description,
    required this.discountType,
    required this.discountValue,
    required this.minOrderValue,
    this.maxDiscountAmount,
    required this.startDate,
    required this.endDate,
    required this.usageLimit,
    required this.usageCount,
    required this.active,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'description': description,
      'discountType': discountType,
      'discountValue': discountValue,
      'minOrderValue': minOrderValue,
      'maxDiscountAmount': maxDiscountAmount,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'usageLimit': usageLimit,
      'usageCount': usageCount,
      'active': active,
    };
  }

  factory VoucherModel.fromMap(Map<String, dynamic> map) {
    return VoucherModel(
      id: map['_id'],
      code: map['code'] ?? '',
      description: map['description'] ?? '',
      discountType: map['discountType'] ?? '',
      discountValue: map['discountValue']?.toDouble() ?? 0.0,
      minOrderValue: map['minOrderValue']?.toDouble() ?? 0.0,
      maxDiscountAmount: map['maxDiscountAmount']?.toDouble(),
      startDate: DateTime.parse(map['startDate']),
      endDate: DateTime.parse(map['endDate']),
      usageLimit: map['usageLimit']?.toInt() ?? 0,
      usageCount: map['usageCount']?.toInt() ?? 0,
      active: map['active'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory VoucherModel.fromJson(String source) =>
      VoucherModel.fromMap(json.decode(source));

  bool isValid() {
    final now = DateTime.now();
    return active &&
        usageCount < usageLimit &&
        now.isAfter(startDate) &&
        now.isBefore(endDate);
  }
}
