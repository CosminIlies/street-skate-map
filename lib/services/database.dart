import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:skate_spots_app/models/review.dart';
import 'package:skate_spots_app/models/spot.dart';
import 'package:skate_spots_app/models/spot_marker.dart';
import 'package:skate_spots_app/models/user.dart';
import 'package:skate_spots_app/services/auth.dart';

class DatabaseService {
  DatabaseService();

  static final CollectionReference spotsCollection =
      FirebaseFirestore.instance.collection('spots');

  static final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  static final FirebaseStorage storage = FirebaseStorage.instance;

  //spots
  static Future<void> addSpot(LatLng position, int type, String name,
      String description, String filePath) async {
    String id =
        position.latitude.toString() + ":" + position.longitude.toString();

    await uploadFile(filePath, id);

    getImageUrl(id).then((imgUrl) {
      spotsCollection.add({
        'userId': AuthService.user!.uid,
        'lat': position.latitude,
        'lng': position.longitude,
        'type': type,
        'name': name,
        'description': description,
        'imgLink': imgUrl
      }).then((value) => print("New Spot Added"));
    });
  }

  static Future<List<SpotMarker>> getSpotsMarkers() async {
    List<SpotMarker> spots = [];

    await spotsCollection.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        SpotMarker spot =
            SpotMarker(doc.id, LatLng(doc["lat"], doc["lng"]), doc["type"]);
        spots.add(spot);
      }
    });

    return spots;
  }

  static Future<Spot> getSpotDetails(String id) async {
    Spot spot = Spot("", "", LatLng(0, 0), 0, "name", "description", "imgLink");
    await spotsCollection.doc(id).get().then((DocumentSnapshot snapshot) {
      spot = Spot(
          snapshot.id,
          snapshot["userId"],
          LatLng(snapshot["lat"], snapshot["lng"]),
          snapshot["type"],
          snapshot["name"],
          snapshot["description"],
          snapshot["imgLink"]);
    });

    return spot;
  }

  //reviews
  static Future<List<Review>> getSpotReviews(String id) async {
    List<Review> reviews = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('spots/' + id + "/reviews")
        .get();

    for (var doc in querySnapshot.docs) {
      reviews
          .add(Review(doc["userId"], doc["name"], doc["body"], doc["stars"]));
    }

    return reviews;
  }

  static Future<UserModel?> getUser(String id) async {
    UserModel? _user;
    try {
      List<String> favoriteSpots = await getFavoritesSpots(id);
      await userCollection.doc(id).get().then((DocumentSnapshot snapshot) {
        _user = UserModel(
            snapshot["id"], snapshot["name"], snapshot["image"], favoriteSpots);
      });
    } catch (e) {
      userCollection.doc(AuthService.user!.uid).set({
        "id": AuthService.user!.uid,
        "name": AuthService.user!.name,
        "image": AuthService.user!.profilePhoto
      });
      return null;
    }

    return _user;
  }

  static Future<List<Review>> addSpotReview(
      String name, String body, int stars, String id) async {
    List<Review> reviews = [];

    await FirebaseFirestore.instance
        .collection('spots/' + id + "/reviews")
        .add({
      'userId': AuthService.user!.uid,
      'name': name,
      'body': body,
      "stars": stars,
    }).then((value) => print("New Review Added"));

    return reviews;
  }

  //favorites
  static Future<void> addSpotToFavorite(String id, String spotId) async {
    await AuthService.refreshUserData();
    await FirebaseFirestore.instance
        .collection('users/' + id + "/favorites")
        .doc(spotId)
        .set({
      'userId': AuthService.user!.uid,
      'spotId': spotId,
    }).then((value) async {
      await AuthService.refreshUserData();
      print("New Spot Added To Favorites");
    });
  }

  static Future<void> removeSpotFromFavorite(String id, String spotId) async {
    await AuthService.refreshUserData();
    await FirebaseFirestore.instance
        .collection('users/' + id + "/favorites")
        .doc(spotId)
        .delete()
        .then((value) async {
      await AuthService.refreshUserData();
    });
  }

  static Future<List<String>> getFavoritesSpots(String id) async {
    List<String> ids = [];

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users/' + id + "/favorites")
        .get();

    for (var doc in querySnapshot.docs) {
      ids.add(doc["spotId"]);
    }

    return ids;
  }

  //upload image
  static Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);
    try {
      await storage.ref('images/$fileName').putFile(file);
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  static Future<String?> getImageUrl(String name) async {
    final ListResult result = await storage.ref('images/').list();
    final List<Reference> allFiles = result.items;

    for (int i = 0; i < allFiles.length; i++) {
      if (allFiles[i].name == name) {
        final String fileUrl = await allFiles[i].getDownloadURL();
        final FullMetadata fileMeta = await allFiles[i].getMetadata();
        return fileUrl;
      }
    }
    Future.forEach<Reference>(allFiles, (file) async {
      if (file.name == name) {
        final String fileUrl = await file.getDownloadURL();
        final FullMetadata fileMeta = await file.getMetadata();
        return fileUrl;
      }
    });
  }
}
