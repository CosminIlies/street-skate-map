import 'package:flutter/material.dart';
import 'package:skate_spots_app/components/review_component.dart';
import 'package:skate_spots_app/models/review.dart';
import 'package:skate_spots_app/models/spot.dart';
import 'package:skate_spots_app/models/user.dart';
import 'package:skate_spots_app/pages/main/all_reviews.dart';
import 'package:skate_spots_app/services/auth.dart';
import 'package:skate_spots_app/services/database.dart';

class DetailsPage extends StatefulWidget {
  final Spot spot;
  const DetailsPage({Key? key, required this.spot}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late Future getReviewsFuture;

  List<Review> reviews = [];
  Review? lastReview;

  @override
  void initState() {
    super.initState();
    getReviewsFuture = _getReviews();
  }

  Future<void> _getReviews() async {
    reviews = await DatabaseService.getSpotReviews(widget.spot.id);
    if (reviews.isNotEmpty) {
      lastReview = reviews[reviews.length - 1];
    }
    print(reviews.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Text(
              widget.spot.name,
              textAlign: TextAlign.center,
            ),
            IconButton(
              onPressed: () async {
                if (AuthService.isFavorite(widget.spot.id)) {
                  await DatabaseService.removeSpotFromFavorite(
                      AuthService.user!.uid, widget.spot.id);
                } else {
                  await DatabaseService.addSpotToFavorite(
                      AuthService.user!.uid, widget.spot.id);
                }
                setState(() {});
              },
              icon: AuthService.isFavorite(widget.spot.id)
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width / 1.7,
              child: ClipRRect(
                child: Image.network(
                  widget.spot.imageLinks,
                  fit: BoxFit.cover,
                ),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(30)),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text("Added by: ",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(
              height: 5,
            ),
            FutureBuilder(
                future: DatabaseService.getUser(widget.spot.userId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                (snapshot.data as UserModel).profilePhoto),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            (snapshot.data as UserModel).name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),
                        )
                      ],
                    );
                  }

                  return const Text("");
                }),
            const SizedBox(
              height: 40,
            ),
            const Text("Type: ",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(
              height: 5,
            ),
            Text(
              Spot.markerType[widget.spot.type],
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            const Text("Description: ",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(
              height: 5,
            ),
            Text(widget.spot.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                )),
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Reviews: ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: getReviewsFuture,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (reviews.isEmpty) {
                      return FlatButton(
                        onPressed: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AllReviews(
                                    reviews: reviews,
                                    spot: widget.spot,
                                  )));
                          setState(() {
                            getReviewsFuture = _getReviews();
                          });
                        },
                        child: const Text(
                            "No reviews now. Be the first how write one!"),
                      );
                    } else {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ReviewComp(
                              review: lastReview!,
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              await Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => AllReviews(
                                            reviews: reviews,
                                            spot: widget.spot,
                                          )));
                              setState(() {
                                getReviewsFuture = _getReviews();
                              });
                            },
                            child: Text(
                              "Click here to see all ${reviews.length} reviews!",
                              style: const TextStyle(color: Colors.black),
                            ),
                          )
                        ],
                      );
                    }
                  default:
                    return const Text("default");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
