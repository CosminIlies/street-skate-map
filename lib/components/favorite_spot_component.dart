import 'package:flutter/material.dart';
import 'package:skate_spots_app/models/spot.dart';
import 'package:skate_spots_app/services/database.dart';

class FavoriteSpotComponent extends StatefulWidget {
  final String spotId;
  const FavoriteSpotComponent({Key? key, required this.spotId})
      : super(key: key);

  @override
  State<FavoriteSpotComponent> createState() => _FavoriteSpotComponentState();
}

class _FavoriteSpotComponentState extends State<FavoriteSpotComponent> {
  late Spot spot;

  Future setSpot() async {
    spot = await DatabaseService.getSpotDetails(widget.spotId);
    return spot;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setSpot(),
      builder: card,
    );
  }

  Widget card(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      return Container(
          decoration: const BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(snapshot.data.imageLinks))),
                      Text(
                        snapshot.data.name + ":",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.white),
                      ),
                      Image.memory(
                        Spot.markerIcons[snapshot.data.type],
                        width: 50,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    "    " + snapshot.data.description,
                    style: const TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ));
    }

    return const Text("Loading");
  }
}
