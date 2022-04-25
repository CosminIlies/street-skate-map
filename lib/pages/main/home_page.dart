import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skate_spots_app/models/spot.dart';
import 'package:skate_spots_app/models/spot_marker.dart';
import 'package:skate_spots_app/pages/main/details_page.dart';
import 'package:skate_spots_app/services/database.dart';
import 'package:skate_spots_app/services/location_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex = 1;
  final Set<Marker> _markers = {};
  late GoogleMapController _googleMapController;

  List<SpotMarker> spots = [];

  Future<void> _addMarker(int index, SpotMarker spot) async {
    final MarkerId markerId = MarkerId('id-' + index.toString());

    final Marker marker = Marker(
      markerId: markerId,
      icon: BitmapDescriptor.fromBytes(Spot.markerIcons[spot.type]),
      position: spot.position,
      onTap: () async {
        Spot spotDetails = await DatabaseService.getSpotDetails(spot.id);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => DetailsPage(spot: spotDetails)));
      },
    );

    setState(() {
      _markers.add(marker);
    });
  }

  void _onMapCreated(GoogleMapController controller) async {
    _googleMapController = controller;

    spots = await DatabaseService.getSpotsMarkers();
    await Spot.setMarkerIcons();

    for (int i = 0; i < spots.length; i++) {
      _addMarker(i, spots[i]);
    }

    await LocationProvider.loc();
    _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(LocationProvider.initialCameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        onPressed: () => _googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
                LocationProvider.initialCameraPosition)),
        child: const Icon(Icons.center_focus_strong),
      ),
      body: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: LocationProvider.initialCameraPosition,
        onMapCreated: _onMapCreated,
        markers: _markers,
      ),
    );
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }
}
