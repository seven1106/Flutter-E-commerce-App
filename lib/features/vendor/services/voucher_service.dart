import 'dart:convert';
import 'dart:developer';
import 'package:emigo/core/constants/constants.dart';
import 'package:emigo/core/constants/error_handler.dart';
import 'package:emigo/core/utils/show_snack_bar.dart';
import 'package:emigo/models/voucher.dart';
import 'package:emigo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class VoucherServices {
  // Tạo voucher mới
  Future<void> createVoucher({
    required BuildContext context,
    required String code,
    required String discountType,
    required double discountValue,
    required double minOrderValue,
    required double maxDiscountAmount,
    required DateTime startDate,
    required DateTime endDate,
    required int usageLimit,
    required String description,

  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      VoucherModel voucher = VoucherModel(
        code: code,
        discountType: discountType,
        discountValue: discountValue,
        minOrderValue: minOrderValue,
        maxDiscountAmount: maxDiscountAmount,
        startDate: startDate,
        endDate: endDate,
        usageLimit: usageLimit,
        description: description, usageCount: 0, active: true,

      );

      http.Response res = await http.post(
        Uri.parse('${Constants.backEndUrl}/create-voucher'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: voucher.toJson(),
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Voucher created successfully!');
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Lấy voucher theo ID
  Future<VoucherModel> fetchVoucherById({
    required BuildContext context,
    required String id,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    VoucherModel voucher = VoucherModel(
      code: '',
      description: '',
      discountType: '',
      discountValue: 0,
      minOrderValue: 0,
      maxDiscountAmount: 0,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      usageLimit: 0,
      usageCount: 0,
      active: false,

    );

    try {
      http.Response res = await http.get(
        Uri.parse('${Constants.backEndUrl}/get-voucher/$id'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      log(res.toString());
      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          voucher = VoucherModel.fromJson(res.body);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return voucher;
  }

  // Lấy tất cả các voucher
  Future<List<VoucherModel>> fetchAllVouchers(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<VoucherModel> voucherList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('${Constants.backEndUrl}/get-vouchers'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            voucherList.add(
              VoucherModel.fromJson(
                jsonEncode(
                  jsonDecode(res.body)[i],
                ),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return voucherList;
  }

  // Xóa voucher theo ID
  Future<void> deleteVoucher({
    required BuildContext context,
    required String id,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      http.Response res = await http.post(
        Uri.parse('${Constants.backEndUrl}/vendor/delete-voucher'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'id': id}),
      );

      httpErrorHandler(
        response: res,
        context: context,
        onSuccess: onSuccess,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
