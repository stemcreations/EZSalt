import 'dart:async';
import 'dart:convert';

import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_salt/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  UserCredential currentUser;
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  Future<String> signInWithApple({List<Scope> scopes = const []}) async {
    bool isAvailable = await AppleSignIn.isAvailable();
    if (isAvailable) {
      final result = await AppleSignIn.performRequests(
          [AppleIdRequest(requestedScopes: scopes)]);
      switch (result.status) {
        case AuthorizationStatus.authorized:
          final appleIdCredential = result.credential;
          final oAuthProvider = OAuthProvider('apple.com');
          final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(appleIdCredential.identityToken),
            accessToken:
                String.fromCharCodes(appleIdCredential.authorizationCode),
          );
          final authResult = await auth.signInWithCredential(credential);
          final User user = authResult.user;

          assert(!user.isAnonymous);
          assert(await user.getIdToken() != null);
          final User currentUser = auth.currentUser;
          assert(user.uid == currentUser.uid);

          DocumentSnapshot snapshot =
              await _fireStore.collection('users').doc(currentUser.uid).get();
          if (await setAccountsRequiredParameters() == false) {
            return 'new user created';
          }
          if (user != null) {
            return 'signInWithApple succeeded';
          } else {
            return 'not signed in';
          }

          return 'end switch case';

        case AuthorizationStatus.error:
          print(result.error.toString());
          throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString(),
          );

        case AuthorizationStatus.cancelled:
          throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER',
            message: 'Sign in aborted by user',
          );
      }
    } else {
      print('apple sign in not available');
    }
  }

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      final User user = userCredential.user;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);
      final User currentUser = auth.currentUser;
      assert(user.uid == currentUser.uid);
      DocumentSnapshot snapshot =
          await _fireStore.collection('users').doc(currentUser.uid).get();
      if (await setAccountsRequiredParameters() == false) {
        return 'new user created';
      }
      if (user != null) {
        return 'signInWithGoogle succeeded';
      } else {
        return 'not signed in';
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
  }

  Future<String> checkAuthenticationState() async {
    if (auth.currentUser == null) {
      return 'not logged in';
    } else {
      return 'logged in';
    }
  }

  Future<String> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (user != null) {
        await setAccountsRequiredParameters();
        return 'Account Created';
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'week-password') {
        return 'Password too weak';
      } else if (e.code == 'email-already-in-use') {
        return 'Email address already in use';
      } else {
        return e.code.toString();
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
    return 'User not created';
  }

  Future profileAndDeviceSetup(
      String deviceID,
      String address,
      String city,
      String state,
      int zipCode,
      int tankDepth,
      String firstName,
      String lastName,
      String phoneProvider,
      String phoneNumber,
      bool enabledDelivery) async {
    try {
      await _fireStore.collection('users').doc(auth.currentUser.uid).update({
        'first_name': firstName,
        'last_name': lastName,
        'phone_provider': phoneProvider,
        'phone': phoneNumber,
        'sensor': deviceID,
        'depth': tankDepth,
        'street_address': address,
        'city': city,
        'state': state,
        'zipcode': zipCode,
        'delivery_enabled': enabledDelivery,
        'temp_percent': 10
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      currentUser = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('user authenticated');
      if (await setAccountsRequiredParameters() == false) {
        return 'new user created';
      }
      return 'user authenticated';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'User not found';
      } else if (e.code == 'wrong-password') {
        return 'Incorrect password';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email';
      }
    } catch (e) {
      return e.toString();
    }
    if (currentUser != null) {
      print('user authenticated');
      return 'user authenticated';
    } else {
      print('not authenticated');
      return 'not authenticated';
    }
  }

  Future<dynamic> getTankLevel() async {
    if (auth.currentUser.uid != null) {
      var tankLevel = await refreshTankLevels();
      if (tankLevel.runtimeType == double) {
        final DocumentSnapshot currentUserTankLevel = await _fireStore
            .collection('users')
            .doc(auth.currentUser.uid)
            .get();
        return currentUserTankLevel.get('temp_percent');
      } else {
        return 'tank level reading failed';
      }
    }
    return null;
  }

  //Gets the current users profile data in dictionary/Map form
  Future<Map> getProfile() async {
    Map profileData;
    if (auth.currentUser == null) {
      return null;
    }
    if (auth.currentUser.uid != null) {
      final DocumentSnapshot currentUserDatabaseProfile =
          await _fireStore.collection('users').doc(auth.currentUser.uid).get();
      profileData = currentUserDatabaseProfile.data();
      return profileData;
    }
    return null;
  }

  Future<String> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return 'success';
    } catch (error) {
      print(error);
      return error;
    }
  }

  Future updateName(String firstName, String lastName) async {
    await _fireStore.collection('users').doc(auth.currentUser.uid).update({
      'first_name': firstName,
      'last_name': lastName,
    });
    await getProfile();
  }

  Future updateAddress(
      String address, String city, String state, int zipCode) async {
    await _fireStore.collection('users').doc(auth.currentUser.uid).update({
      'street_address': address,
      'city': city,
      'state': state,
      'zipcode': zipCode,
    });
    await getProfile();
  }

  Future updateEmail(String email) async {
    await _fireStore.collection('users').doc(auth.currentUser.uid).update({
      'email': email,
    });
    await getProfile();
  }

  Future updatePhone(String phoneNumber, String phoneProvider) async {
    await _fireStore.collection('users').doc(auth.currentUser.uid).update({
      'phone_provider': phoneProvider,
      'phone': phoneNumber,
    });
    await getProfile();
  }

  Future updateTankDepth(int tankDepth) async {
    await _fireStore.collection('users').doc(auth.currentUser.uid).update({
      'depth': tankDepth,
    });
    await getProfile();
  }

  Future updateDeliveryEnabled(bool enableDelivery) async {
    await _fireStore.collection('users').doc(auth.currentUser.uid).update({
      'delivery_enabled': enableDelivery,
    });
    await getProfile();
  }

  Future updateTankDepthNotification(int tankPercent) async {
    await _fireStore.collection('users').doc(auth.currentUser.uid).update({
      'send_percent': {'high': null, 'low': tankPercent},
    });
    await getProfile();
  }

  Future updateSensor(String deviceID) async {
    await _fireStore.collection('users').doc(auth.currentUser.uid).update({
      'sensor': deviceID,
    });
    await getProfile();
  }

  Future<bool> setAccountsRequiredParameters() async {
    final User currentUser = auth.currentUser;
    DocumentSnapshot snapshot =
        await _fireStore.collection('users').doc(currentUser.uid).get();
    if (!snapshot.exists) {
      print('creating document');
      await _fireStore.collection('users').doc(currentUser.uid).set({
        'first_name': null,
        'last_name': null,
        'email': currentUser.email,
        'phone': null,
        'send_percent': {'high': null, 'low': 15},
        'percent': 10.0,
        'distance': 15,
        'phone_provider': null,
        'sensor': null,
        'depth': 90,
        'street_address': null,
        'city': null,
        'state': null,
        'zipcode': null,
        'delivery_enabled': false,
        'temp_percent': 10
      });
      return false;
    }
    await checkAccountsRequiredParameters();
    return true;
  }

  Future checkAccountsRequiredParameters() async {
    Map userProfile;
    final User currentUser = auth.currentUser;
    DocumentSnapshot snapshot =
        await _fireStore.collection('users').doc(currentUser.uid).get();
    if (snapshot.exists) {
      userProfile = await getProfile();
      for (final parameter in requiredAccountParameters) {
        if (!userProfile.containsKey(parameter)) {
          if (parameter == 'delivery_enabled') {
            await _fireStore.collection('users').doc(currentUser.uid).update({
              parameter: false,
            });
            print('missing boolean');
          } else if (parameter != 'zipcode' &&
              parameter != 'percent' &&
              parameter != 'distance' &&
              parameter != 'depth' &&
              parameter != 'send_percent' &&
              parameter != 'phone_provider' &&
              parameter != 'delivery_enabled') {
            await _fireStore
                .collection('users')
                .doc(currentUser.uid)
                .update({parameter: null});
            print('missing strings');
          } else if (parameter != 'send_percent' &&
              parameter != 'phone_provider' &&
              parameter != 'delivery_enabled') {
            await _fireStore
                .collection('users')
                .doc(currentUser.uid)
                .update({parameter: null});
            print('integers');
          } else if (parameter == 'send_percent' &&
              parameter != 'phone_provider' &&
              parameter != 'delivery_enabled') {
            await _fireStore.collection('users').doc(currentUser.uid).update({
              parameter: {'high': null, 'low': 15},
            });
            print('send percent');
          } else if (parameter == 'phone_provider') {
            await _fireStore.collection('users').doc(currentUser.uid).update({
              parameter: null,
            });
            print('phone number');
          }
        }
      }
    }
    return null;
  }

  Future<Map> getPhoneProviders() async {
    Map data = {};
    Map phoneProviders = {};
    final DocumentSnapshot phoneProviderSnapshot =
        await _fireStore.collection('variables').doc('Admin').get();
    data = phoneProviderSnapshot.data();
    phoneProviders = data['ProviderOptions'];
    return phoneProviders;
  }

  Future<bool> checkDeliveryZipCodes(int zipCode) async {
    Map data = {};
    List deliveryZipCodes = [];
    final DocumentSnapshot phoneProviderSnapshot =
        await _fireStore.collection('variables').doc('Admin').get();
    data = phoneProviderSnapshot.data();
    deliveryZipCodes = data['delivery_zip_codes'];
    if (deliveryZipCodes.contains(zipCode)) {
      return true;
    }
    return false;
  }

  Future addDeliveryZipCode(int zipCode) async {
    Map data = {};
    //TODO create way to add delivery zipcodes to database
    List deliveryZipCodes = [];
    final DocumentSnapshot phoneProviderSnapshot =
        await _fireStore.collection('variables').doc('Admin').get();
    data = phoneProviderSnapshot.data();
    deliveryZipCodes = data['delivery_requested'];
  }

  Future<Map> getPhoneProvidersReversed() async {
    Map phoneProvidersReversed = {};
    Map phoneProviders = await getPhoneProviders();
    for (final provider in phoneProviders.keys) {
      phoneProvidersReversed.addAll({phoneProviders[provider]: provider});
    }
    return phoneProvidersReversed;
  }

  Future<dynamic> refreshTankLevels() async {
    String uid = auth.currentUser.uid;
    if (await checkAuthenticationState() == 'logged in') {
      Map profileData = await getProfile();
      String sensorId = profileData['sensor'];
      String url =
          'https://us-central1-ezsalt-iot-dev-env.cloudfunctions.net/api/refresh/?uid=$uid&sid=$sensorId';
      try {
        var response =
            await http.get(url).timeout(Duration(seconds: 7), onTimeout: () {
          return null;
        });
        if (response != null) {
          Map<String, dynamic> decodedData = jsonDecode(response.body);
          if (decodedData['status'] == 'success') {
            return decodedData['percent'];
          } else if (decodedData['status'] == 'low_level') {
            return decodedData['percent'];
          } else {
            return 'Failed to get sensor reading';
          }
        }
      } on FormatException catch (e) {
        print(e.message);
        return 'Sensor Reading Failed';
      }
    }
  }
}
