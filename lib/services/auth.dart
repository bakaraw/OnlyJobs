import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      //fb_auth.UserCredential result = await _auth
      fb_auth.UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      fb_auth.User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // register with email and passwordss
  Future registerEmailAndPassword(String email, String password) async {
    try {
      fb_auth.UserCredential result = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      fb_auth.User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      _auth.signOut();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  Future<String?> getCurrentUserName() async {
    final userId = _auth.currentUser?.uid;
    if (userId != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('User').doc(userId).get();
      return userDoc['name'];
    }
    return null;
  }

}
