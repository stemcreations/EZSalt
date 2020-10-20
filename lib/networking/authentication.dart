import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  UserCredential  currentUser;
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future createUserWithEmailAndPassword(
      String email, String password, String firstName, String lastName, String sensor,
      String address, String city, String state, int zipCode, String phoneNumber,
      int depth, String phoneProvider) async {

    UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
    _fireStore.collection('users').doc(user.user.uid).set({
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'sensor': sensor,
      'depth': 90,
      'street_address': address,
      'city': city,
      'state': state,
      'zipcode': zipCode,
      'phone': phoneNumber,
      'send_percent':{'high': null, 'low': 15},
      'percent': 88.0,
      'distance': 15,
      'phone_provider': phoneProvider,
    });
  }

  Future signInWithEmailAndPassword(String email, String password) async {
      currentUser = await auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
  }

  //TODO add functionality to push a refresh on the sensor via API... I don't know if API currently exists to do this.
  Future<double> getTankLevel() async {
    if (auth.currentUser.uid != null){
    final DocumentSnapshot currentUserTankLevel = await _fireStore
        .collection('users').doc(auth.currentUser.uid).get();
    return currentUserTankLevel.get('percent');
    }
    return null;
  }

  //Gets the current users profile data in dictionary/Map form
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