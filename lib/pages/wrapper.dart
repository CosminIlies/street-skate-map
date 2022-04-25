import 'package:flutter/material.dart';
import 'package:skate_spots_app/pages/authenticate/authenticate_page.dart';
import 'package:skate_spots_app/pages/main/main_page.dart';
import 'package:skate_spots_app/services/auth.dart';

class Wrapper extends StatelessWidget {
  final int currentPage;
  const Wrapper({Key? key, required this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthService.user == null
        ? const AuthenticatePage()
        : MainPage(
            currentPage: currentPage,
          );
  }
}
