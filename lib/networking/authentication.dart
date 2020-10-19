import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  UserCredential currentUser;
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInWithEmailAndPassword(String email, String password) async {
    //Must initializeAPP with new updates and must use cloud fireStore
    Firebase.initializeApp();
    try {
      currentUser = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      //catch login exceptions
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  //TODO add functionality to push a refresh on the sensor via API... I dont know if API currently exists to do this.
  Future<double> getTankLevel() async {
    if (_auth.currentUser.uid != null){
    final DocumentSnapshot currentUserTankLevel = await _fireStore
        .collection('users').doc(_auth.currentUser.uid).get();
    return currentUserTankLevel.get('percent');
    }
    return null;
  }

  Future<Map> getProfile() async {
    Map profileData;
    if (_auth.currentUser.uid != null){
      final DocumentSnapshot currentUserDatabaseProfile = await _fireStore
          .collection('users').doc(_auth.currentUser.uid).get();
      profileData = currentUserDatabaseProfile.data();
      return profileData;
    }
    return null;
  }
}