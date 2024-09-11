import 'package:emigo/core/common/custom_textfield.dart';
import 'package:emigo/core/common/long_button.dart';
import 'package:emigo/core/constants/constants.dart';
import 'package:emigo/features/account/services/account_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';

class EditUserInfo extends StatefulWidget {
  static const String routeName = 'edit_user_info';
  const EditUserInfo({Key? key}) : super(key: key);

  @override
  _EditUserInfoState createState() => _EditUserInfoState();
}

class _EditUserInfoState extends State<EditUserInfo> {
  final _signUpFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final AccountService _accountService = AccountService();
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
  }
  void _signUp() {
    _accountService.editUserInformation(
      context: context,
      email: _emailController.text,
      name: _nameController.text,
      phone: _phoneController.text,
    );
  }
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    _nameController.text = user.name;
    _phoneController.text = user.phone;
    _emailController.text = user.email;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(
                child: Column(
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(Constants.logoPath),
                  ],
                ),
              ),
                Form(
                  key: _signUpFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                          controller: _nameController, hintText: 'Name'),
                      CustomTextField(
                          controller: _emailController, hintText: 'Email'),
                      CustomTextField(
                          controller: _phoneController, hintText: 'Phone'),
                      LongButton(
                          buttonText: 'Save',
                          onPressed: () {
                            if (_signUpFormKey.currentState!.validate()) {
                              _signUp();
                            }
                          }),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

}
