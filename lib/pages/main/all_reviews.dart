import 'package:flutter/material.dart';
import 'package:skate_spots_app/components/review_component.dart';
import 'package:skate_spots_app/models/review.dart';
import 'package:skate_spots_app/models/spot.dart';
import 'package:skate_spots_app/pages/main/add_review.dart';

class AllReviews extends StatefulWidget {
  final List<Review> reviews;
  final Spot spot;
  const AllReviews({Key? key, required this.reviews, required this.spot})
      : super(key: key);

  @override
  State<AllReviews> createState() => _AllReviewsState();
}

class _AllReviewsState extends State<AllReviews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text(
          widget.spot.name,
          textAlign: TextAlign.center,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: widget.reviews.map((review) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ReviewComp(review: review),
          );
        }).toList()),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddReviewPage(id: widget.spot.id)));
          Navigator.of(context).pop();
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }
}
