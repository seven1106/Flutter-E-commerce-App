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

class AuthScreen extends StatefulWidget {
  static const String routeName = 'auth_screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  Auth _auth = Auth.signUp;
  final _signUpFormKey = GlobalKey<FormState>();
  final _signInFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _obscureText = true;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
  }

  void _signUp() {
    _authService.signUp(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      name: _nameController.text,
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
                      const SizedBox(height: 20),
                      ListTile(
                        tileColor: _auth == Auth.signIn
                            ? AppPalette.gradient3.withOpacity(0.5)
                            : AppPalette.backgroundColor,
                        title: const Text(
                          'Sign-In.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: Radio(
                          activeColor: AppPalette.gradient3,
                          value: Auth.signIn,
                          groupValue: _auth,
                          onChanged: (Auth? val) {
                            setState(() {
                              _auth = val!;
                            });
                          },
                        ),
                      ),
                      LongButton(
                          buttonText: 'Sign Up',
                          onPressed: () {
                            if (_signUpFormKey.currentState!.validate()) {
                              _signUp();
                            }
                          }),
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
                      const SizedBox(height: 20),
                      ListTile(
                        tileColor: _auth == Auth.signUp
                            ? AppPalette.gradient3.withOpacity(0.5)
                            : AppPalette.backgroundColor,
                        title: const Text(
                          'Sign-Up.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        leading: Radio(
                          activeColor: AppPalette.gradient3,
                          value: Auth.signUp,
                          groupValue: _auth,
                          onChanged: (Auth? val) {
                            setState(() {
                              _auth = val!;
                            });
                          },
                        ),
                      ),
                      LongButton(buttonText: 'Sign In', onPressed: () {
                        if (_signInFormKey.currentState!.validate()) {
                          _signIn();
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
