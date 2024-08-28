import 'package:emigo/core/common/custom_textfield.dart';
import 'package:emigo/core/common/long_button.dart';
import 'package:emigo/core/config/theme/app_palette.dart';
import 'package:emigo/core/constants/constants.dart';
import 'package:emigo/features/auth/services/auth_service.dart';
import 'package:flutter/material.dart';

enum Auth {
  signIn,
  signUp,
}

enum Role {
  user,
  vendor,
}

class AuthScreen extends StatefulWidget {
  static const String routeName = 'auth_screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signIn;
  Role _role = Role.user;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _obscureText = true;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
  }

  void _signUp() {
    _authService.signUp(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
      phone: _phoneController.text,
      role: 'user',
    );
  }

  void _signIn() {
    _authService.signIn(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
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
              if (_auth == Auth.signUp)
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
                      TextFormField(
                        obscuringCharacter: '*',
                        obscureText: _obscureText,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          suffixIcon: showHidePassword(),
                          labelText: 'Password',
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 1),
                      // Row(
                      //   children: [
                      //     const Text('Role:',
                      //         style: TextStyle(
                      //           fontSize: 20,
                      //         )),
                      //     Radio(
                      //       activeColor: AppPalette.gradient3,
                      //       value: Role.user,
                      //       groupValue: _role,
                      //       onChanged: (Role? val) {
                      //         setState(() {
                      //           _role = val!;
                      //         });
                      //       },
                      //     ),
                      //     const Text('User', style: TextStyle(fontSize: 16)),
                      //     const SizedBox(width: 10),
                      //     Radio(
                      //       activeColor: AppPalette.gradient3,
                      //       value: Role.vendor,
                      //       groupValue: _role,
                      //       onChanged: (Role? val) {
                      //         setState(() {
                      //           _role = val!;
                      //         });
                      //       },
                      //     ),
                      //     const Text('Vendor', style: TextStyle(fontSize: 16)),
                      //   ],
                      // ),
                      const SizedBox(height: 10),
                      LongButton(
                          buttonText: 'Sign Up',
                          onPressed: () {
                            if (_signUpFormKey.currentState!.validate()) {
                              _signUp();
                            }
                          }),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _auth = Auth.signIn;
                          });
                        },
                        child: const Text(
                          'Already have an account? Sign-In.',
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_auth == Auth.signIn)
                Form(
                  key: _signInFormKey,
                  child: Column(
                    children: [
                      CustomTextField(
                          controller: _emailController, hintText: 'Email'),
                      TextFormField(
                        obscuringCharacter: '*',
                        obscureText: _obscureText,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          suffixIcon: showHidePassword(),
                          labelText: 'Password',
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      LongButton(
                          buttonText: 'Sign In',
                          onPressed: () {
                            if (_signInFormKey.currentState!.validate()) {
                              _signIn();
                            }
                          }),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _auth = Auth.signUp;
                          });
                        },
                        child: const Text(
                          'Don\'t have an account? Sign-Up.',
                          style: TextStyle(
                            fontSize: 16,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showHidePassword() {
    return IconButton(
      icon: _obscureText
          ? const Icon(Icons.visibility_off, color: Colors.black)
          : const Icon(Icons.visibility, color: Colors.black),
      onPressed: () {
        setState(() {
          _obscureText = !_obscureText;
        });
      },
    );
  }
}
