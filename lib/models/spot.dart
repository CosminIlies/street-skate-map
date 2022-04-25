import 'dart:typed_data';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skate_spots_app/tools/image_loader.dart';

class Spot {
  static List<Uint8List> markerIcons = [];
  static List<String> markerType = [];

  final String id;
  final String userId;
  final LatLng position;
  final int type;
  final String name;
  final String description;
  final String imageLinks;

  Spot(this.id, this.userId, this.position, this.type, this.name,
      this.description, this.imageLinks);

  static Future<void> setMarkerIcons() async {
    markerIcons = [
      await ImageLoader.getBytesFromAsset('res/markerRamp.png', 125),
      await ImageLoader.getBytesFromAsset('res/markerStairs.png', 125),
      await ImageLoader.getBytesFromAsset('res/markerRails.png', 125),
    ];

    markerType = ["Ramp", "Stairs", "Rails"];
  }
}
