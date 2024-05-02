import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = 'auth_screen';
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Screen'),
      ),
      body: const Center(
        child: Text('This is the Auth Screen'),
      ),
    );
  }
}
