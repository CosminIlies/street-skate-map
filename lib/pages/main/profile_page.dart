import 'package:flutter/material.dart';
import 'package:skate_spots_app/services/auth.dart';

class PrfilePage extends StatefulWidget {
  const PrfilePage({Key? key}) : super(key: key);

  @override
  State<PrfilePage> createState() => _PrfilePageState();
}

class _PrfilePageState extends State<PrfilePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: NetworkImage(AuthService.user!.profilePhoto),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          AuthService.user!.name,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 15),
        ),
      ],
    ));
  }
}
