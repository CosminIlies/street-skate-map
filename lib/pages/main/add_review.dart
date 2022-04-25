import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:skate_spots_app/services/auth.dart';
import 'package:skate_spots_app/services/database.dart';

class AddReviewPage extends StatefulWidget {
  final String id;
  const AddReviewPage({Key? key, required this.id}) : super(key: key);

  @override
  State<AddReviewPage> createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  double stars = 0;
  String body = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green,
          title: const Text(
            "Add new review",
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Tell us what do you think about this spot:",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                maxLines: 5,
                minLines: 5,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: "Review:"),
                textAlign: TextAlign.center,
                onChanged: (str) => body = str,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Stars:",
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            RatingBar.builder(
              minRating: 1,
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.green,
              ),
              onRatingUpdate: (rateing) => setState(() {
                stars = rateing;
              }),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 25),
              child: ElevatedButton(
                onPressed: () async {
                  await DatabaseService.addSpotReview(
                      AuthService.user!.name, body, stars.toInt(), widget.id);

                  Navigator.of(context).pop();

                },
                child: const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
                  child: Text("Post"),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  alignment: Alignment.centerRight,
                ),
              ),
            ),
          ],
        ));
  }
}
