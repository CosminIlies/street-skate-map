import 'package:flutter/material.dart';
import 'package:skate_spots_app/pages/wrapper.dart';
import 'package:skate_spots_app/services/auth.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        FlatButton(onPressed: () {}, child: const Text("Your spots")),
        FlatButton(
            onPressed: () {
              AuthService.signOut();
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const Wrapper(
                        currentPage: 2,
                      )));
            },
            child: const Text("LogOut")),
      ],
    ));
  }
}
