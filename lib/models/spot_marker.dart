import 'package:google_maps_flutter/google_maps_flutter.dart';

class SpotMarker {
  String id;
  LatLng position;
  int type;

  SpotMarker(this.id, this.position, this.type);
}
