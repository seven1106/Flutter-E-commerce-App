import 'dart:convert';
import 'dart:developer';

import 'package:emigo/core/common/user_screen.dart';
import 'package:emigo/core/constants/constants.dart';
import 'package:emigo/core/constants/error_handler.dart';
import 'package:emigo/features/vendor/screens/vendor_screen.dart';
import 'package:emigo/models/user_model.dart';
import 'package:emigo/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utils/show_snack_bar.dart';

class AuthService {
  void signUp(
      {required BuildContext context,
      required String email,
      required String phone,
      required String password,
      required String name,
      required String role}) async {
    try {
      UserModel user = UserModel(
        id: '',
        name: name,
        email: email,
        phone: phone,
        password: password,
        address: '',
        type: role,
        token: '',
        cart: [],
        wishlist: [],
        notifications: [],
      );
      http.Response response = await http.post(
        Uri.parse('${Constants.backEndUrl}/sign-up'),
        body: user.toJson(),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () {
          showSnackBar(
            context,
            'Account created! Login with the same credentials!',
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void signIn({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response response = await http.post(
        Uri.parse('${Constants.backEndUrl}/sign-in'),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      // ignore: use_build_context_synchronously
      httpErrorHandler(
        response: response,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(
            response.body,
          );
          await prefs.setString(
              'x-auth-token', jsonDecode(response.body)['token']);
          log(jsonDecode(response.body).toString());
          log('pref: ${prefs.getString('x-auth-token')}');
          if (jsonDecode(response.body)['type'] == 'vendor') {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const VendorScreen(),
              ),
            );
          } else {
            // ignore: use_build_context_synchronously
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const UserScreen(),
              ),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void getUserData(
     BuildContext context,
  ) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');
      log('token: $token');
      if (token == null) {
        prefs.setString('x-auth-token', '');
      }
      var tokenResponse = await http.post(
        Uri.parse('${Constants.backEndUrl}/token-is-valid'),
        body: jsonEncode({
          'token': token!,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );

      var tokenData = jsonDecode(tokenResponse.body);
      log('tokenData.toString()$tokenData');
      if (tokenData == true) {
        http.Response userRes = await http.get(
          Uri.parse('${Constants.backEndUrl}/auth'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token
          },
        );
        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.body);
        log('userRes.body: ${userRes.body}');
        log('userProvider.user: ${userProvider.user.token}');
      }
    } catch (e) {
      showSnackBar(context, 'Please login again');
    }
  }
}
