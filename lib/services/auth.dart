import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:only_job/models/user.dart';
import 'dart:developer';

class AuthService {
  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;

  // create user object based on firebase user
  User? _userFromFirebaseUser(fb_auth.User? user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream
  Stream<User?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // sign in anonymously
  Future signInAnon() async {
    try {
      fb_auth.UserCredential result = await _auth.signInAnonymously();
      fb_auth.User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // sign in with password

  // sign out
  Future signOut() async {
    try {
      _auth.signOut();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
