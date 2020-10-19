import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  UserCredential currentUser;
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future signInWithEmailAndPassword(String email, String password) async {
      currentUser = await auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
  }

  //TODO add functionality to push a refresh on the sensor via API... I dont know if API currently exists to do this.
  Future<double> getTankLevel() async {
    if (auth.currentUser.uid != null){
    final DocumentSnapshot currentUserTankLevel = await _fireStore
        .collection('users').doc(auth.currentUser.uid).get();
    return currentUserTankLevel.get('percent');
    }
    return null;
  }

  Future<Map> getProfile() async {
    Map profileData;
    if (auth.currentUser.uid != null){
      final DocumentSnapshot currentUserDatabaseProfile = await _fireStore
          .collection('users').doc(auth.currentUser.uid).get();
      profileData = currentUserDatabaseProfile.data();
      return profileData;
    }
    return null;
  }
}