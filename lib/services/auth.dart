import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:skate_spots_app/services/database.dart';

import '../models/user.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  static UserModel? _user;

  Future<UserModel?> _transformInUserModel(User? user) async {
    List<String> favorites = await DatabaseService.getFavoritesSpots(user!.uid);
    return user != null
        ? UserModel(user.uid, user.displayName!, user.photoURL!, favorites)
        : null;
  }

  static refreshUserData() async {
    if (_user == null) return;

    List<String> favorites = await DatabaseService.getFavoritesSpots(user!.uid);
    _user = UserModel(_user!.uid, _user!.name, _user!.profilePhoto, favorites);
  }

  static UserModel? get user {
    return _user;
  }

  static bool isFavorite(String spotId) {
    for (int i = 0; i < _user!.favoritesSpots.length; i++) {
      if (_user!.favoritesSpots[i].toString() == spotId.toString()) {
        print("FOUND");
        return true;
      }
    }
    return false;
  }

  Future signInAnon() async {
    try {
      UserCredential _userCredential = await _auth.signInAnonymously();
      User? user = _userCredential.user;
      _user = await _transformInUserModel(user);
      return _user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future googleLogIn() async {
    final googleUser = await googleSignIn.signIn();

    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    _user = await _transformInUserModel(userCredential.user);
    DatabaseService.getUser(AuthService.user!.uid);
    return _user;
  }

  //sign out

  static Future signOut() async {
    _auth.signOut();
    _user = null;
  }
}
