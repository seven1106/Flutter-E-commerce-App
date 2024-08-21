import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/show_snack_bar.dart';

void httpErrorHandler({
  required http.Response response,
  required BuildContext context,
  required VoidCallback onSuccess,
}) {
  final jsonResponse = jsonDecode(response.body);

  void showErrorMessage(String? errorMessage) {
    if (errorMessage != null) {
      showSnackBar(context, errorMessage);
      log(errorMessage);
      print(jsonResponse['error']);
    } else {
      showSnackBar(context, "Unknown error occurred");
    }
  }

  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
      showErrorMessage(jsonResponse['error'].toString());
      print(jsonResponse['error']);
      break;
    case 500:
      showErrorMessage(jsonResponse['error'].toString());
      print(jsonResponse['error']);
      break;
    default:
      showSnackBar(context, response.body);
  }
}
