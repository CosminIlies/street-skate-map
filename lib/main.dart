import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skate_spots_app/pages/main/main_page.dart';
import 'package:skate_spots_app/pages/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  runApp(MyApp());
}

/*
  TODO: custorm markers(
      flat,
      ledgs,
    )
    
    marker clustering,

    update when finished adding new spot and review
                  ^
                  |
                  repair it
    
*/
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Skate Spots',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.green,
        ),
        home: const Wrapper(
          currentPage: 2,
        ),
        debugShowCheckedModeBanner: true);
  }
}
