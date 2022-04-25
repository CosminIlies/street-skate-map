import 'package:flutter/material.dart';
import 'package:skate_spots_app/pages/authenticate/login_page.dart';

class AuthenticatePage extends StatefulWidget {
  const AuthenticatePage({Key? key}) : super(key: key);

  @override
  State<AuthenticatePage> createState() => _AuthenticatePageState();
}

class _AuthenticatePageState extends State<AuthenticatePage> {
  @override
  Widget build(BuildContext context) {
    return const LoginPage();
  }
}
