import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:skate_spots_app/models/review.dart';
import 'package:skate_spots_app/models/user.dart';
import 'package:skate_spots_app/services/database.dart';

class ReviewComp extends StatefulWidget {
  final Review review;
  const ReviewComp({Key? key, required this.review}) : super(key: key);

  @override
  State<ReviewComp> createState() => _ReviewCompState();
}

class _ReviewCompState extends State<ReviewComp> {
  @override
  Widget build(BuildContext context) {
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
                      child: FutureBuilder(
                          future: DatabaseService.getUser(widget.review.userId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              UserModel usrMdl = snapshot.data as UserModel;
                              return CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(usrMdl.profilePhoto));
                            }
                            return const Text("Not done");
                          }),
                    ),
                    Text(
                      widget.review.name + ":",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  "    " + widget.review.body,
                  style: const TextStyle(fontSize: 15, color: Colors.white),
                ),
                const SizedBox(
                  height: 15,
                ),
                RatingBarIndicator(
                  rating: widget.review.stars.toDouble(),
                  unratedColor: Colors.grey,
                  itemSize: 25,
                  itemBuilder: (context, type) =>
                      const Icon(Icons.star, color: Colors.white),
                ),
              ],
            ),
          ),
        ));
  }
}
