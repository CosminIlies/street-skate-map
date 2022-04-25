import 'package:flutter/material.dart';

class UserModel {
  final String uid;
  final String name;
  final String profilePhoto;
  final List<String> favoritesSpots;
  UserModel(this.uid, this.name, this.profilePhoto, this.favoritesSpots);
}
