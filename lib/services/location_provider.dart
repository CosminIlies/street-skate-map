import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationProvider {
  static LatLng locationPosition = const LatLng(0, 0);
  static CameraPosition initialCameraPosition =
      const CameraPosition(target: LatLng(0, 0), zoom: 15);

  static bool initialized = false;

  static Future<void> loc() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    await location.getLocation().then((LocationData currentLocation) {
      locationPosition =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);

      initialCameraPosition =
          CameraPosition(target: locationPosition, zoom: 15);
    });

    location.onLocationChanged.listen((LocationData currentLocation) {
      locationPosition =
          LatLng(currentLocation.latitude!, currentLocation.longitude!);

      initialCameraPosition =
          CameraPosition(target: locationPosition, zoom: 15);
    });
  }
}
