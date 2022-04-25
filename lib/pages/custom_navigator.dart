import 'package:flutter/material.dart';
import 'package:skate_spots_app/pages/wrapper.dart';

class CustomNavigator {
  static goToMain(BuildContext context, int page) async {
    await Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Wrapper(currentPage: page)),
        (route) => route.isFirst);
  }
}
