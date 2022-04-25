import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skate_spots_app/pages/custom_navigator.dart';
import 'package:skate_spots_app/services/camera_service.dart';
import 'package:skate_spots_app/services/database.dart';
import 'package:skate_spots_app/services/location_provider.dart';
import 'package:skate_spots_app/tools/image_loader.dart';

class AddSpotPage extends StatefulWidget {
  const AddSpotPage({Key? key}) : super(key: key);

  @override
  State<AddSpotPage> createState() => _AddSpotPageState();
}

class _AddSpotPageState extends State<AddSpotPage> {
  int _phase = 0;

  late LatLng position;
  late int type = 0;
  late String name;
  late String description;
  File? img;

  final Set<Marker> _markers = {};
  List<Uint8List> markerIcons = [];

  CameraPosition initialCameraPosition =
      const CameraPosition(target: LatLng(0, 0), zoom: 15);

  late GoogleMapController _googleMapController;

  void _onMapCreated(GoogleMapController controller) async {
    markerIcons = [
      await ImageLoader.getBytesFromAsset('res/markerRamp.png', 125),
      await ImageLoader.getBytesFromAsset('res/markerStairs.png', 125),
      await ImageLoader.getBytesFromAsset('res/markerRails.png', 125),
    ];
    _googleMapController = controller;

    _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(LocationProvider.initialCameraPosition));
  }

  @override
  Widget build(BuildContext context) {
    final _scenes = [
      //details
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: TextField(
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: "Name"),
              textAlign: TextAlign.center,
              onChanged: (str) => name = str,
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
            child: TextField(
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Description"),
                textAlign: TextAlign.center,
                onChanged: (str) => description = str),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Type: ",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: DropdownButton<int>(
                      style: const TextStyle(color: Colors.white),
                      borderRadius: const BorderRadius.all(Radius.circular(5)),
                      dropdownColor: Colors.green,
                      underline: const SizedBox(),
                      value: type,
                      items: const [
                        DropdownMenuItem<int>(value: 0, child: Text("Ramp")),
                        DropdownMenuItem<int>(value: 1, child: Text("Stairs")),
                        DropdownMenuItem<int>(value: 2, child: Text("Rail")),
                      ],
                      onChanged: (int? index) {
                        setState(() => type = index!);
                      }),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25),
            child: ElevatedButton(
              onPressed: () => setState(() {
                _phase++;
              }),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: Text("Next"),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                alignment: Alignment.centerRight,
              ),
            ),
          )
        ],
      ),

      //position
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              initialCameraPosition: initialCameraPosition,
              onMapCreated: _onMapCreated,
              markers: _markers,
              onTap: (LatLng pos) {
                position = pos;

                final Marker marker = Marker(
                  markerId: const MarkerId('id-1'),
                  icon: BitmapDescriptor.fromBytes(markerIcons[type]),
                  position: pos,
                );
                setState(() {
                  _markers.clear();
                  _markers.add(marker);
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25),
            child: ElevatedButton(
              onPressed: () => setState(() {
                _phase++;
              }),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                child: Text("Next"),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                alignment: Alignment.centerRight,
              ),
            ),
          )
        ],
      ),

      //photos
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width / 1.7,
            color: Colors.black,
            child: img != null
                ? Image.file(img!, fit: BoxFit.cover)
                : const Text("no image"),
          ),
          const SizedBox(height: 15), // TODO: check this
          const Text("Choose photo: "),

          ElevatedButton.icon(
            icon: const Icon(Icons.camera),
            label: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: Text("Take a photo"),
            ),
            onPressed: () {
              CameraService.pickImageFromCamera()
                  .then((image) => setState(() => img = image));
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              alignment: Alignment.centerRight,
            ),
          ),

          ElevatedButton.icon(
            icon: const Icon(Icons.photo),
            label: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
              child: Text("Pick one from gallery"),
            ),
            onPressed: () {
              CameraService.pickImageFromGallery()
                  .then((image) => setState(() => img = image));
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.green,
              alignment: Alignment.centerRight,
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25),
            child: ElevatedButton(
              onPressed: () async {
                if (img != null) {
                  await DatabaseService.addSpot(
                      position, type, name, description, img!.path);

                  await CustomNavigator.goToMain(context, 3);
                }
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                child: const Text("Finish"),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                alignment: Alignment.centerRight,
              ),
            ),
          )
        ],
      ),
    ];

    return Center(
      child: _scenes[_phase],
    );
  }
}
