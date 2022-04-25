import 'package:flutter/material.dart';
import 'package:skate_spots_app/components/favorite_spot_component.dart';
import 'package:skate_spots_app/services/auth.dart';
import 'package:skate_spots_app/services/database.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: const Text(
          "Favorites",
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: AuthService.user!.favoritesSpots.map((spot) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: FavoriteSpotComponent(spotId: spot),
          );
        }).toList()),
      ),
    );
  }
}
