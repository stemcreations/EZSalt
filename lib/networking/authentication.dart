import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_salt/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  UserCredential currentUser;
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signInWithApple({List<Scope> scopes = const []}) async {
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
          await checkAccountsRequiredParameters();
          await setAccountsRequiredParameters();
          return;

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
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
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

    return 'signInWithGoogle succeeded';
  }

  void signOut() async {
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

  Future createUserWithEmailAndPassword(String email, String password) async {
    UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    await setAccountsRequiredParameters();
  }

  Future profileAndDeviceSetup(
      String deviceID,
      String address,
      String city,
      String state,
      int zipCode,
      int tankDepth,
      firstName,
      lastName,
      phoneProvider,
      phoneNumber) async {
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
    });
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    currentUser =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    await setAccountsRequiredParameters();
    if (currentUser != null) {
      return currentUser;
    } else {
      return null;
    }
  }

  Future getTankLevel() async {
    if (auth.currentUser.uid != null) {
      final DocumentSnapshot currentUserTankLevel =
          await _fireStore.collection('users').doc(auth.currentUser.uid).get();
      return currentUserTankLevel.get('percent');
    }
    return null;
  }

  //Gets the current users profile data in dictionary/Map form
  Future<Map> getProfile() async {
    Map profileData;
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
    print('finished');
  }

  Future updateAddress(
      String address, String city, String state, int zipCode) async {
    await _fireStore.collection('users').doc(auth.currentUser.uid).update({
      'street_address': address,
      'city': city,
      'state': state,
      'zipcode': zipCode,
    });
  }

  Future updateEmail(String email) async {
    await _fireStore.collection('users').doc(auth.currentUser.uid).update({
      'email': email,
    });
  }

  Future updatePhone(String phoneNumber, String phoneProvider) async {
    await _fireStore.collection('users').doc(auth.currentUser.uid).update({
      'phone_provider': phoneProvider,
      'phone': phoneNumber,
    });
  }

  Future updateTankDepth(int tankDepth) async {
    await _fireStore.collection('users').doc(auth.currentUser.uid).update({
      'depth': tankDepth,
    });
  }

  Future updateTankDepthNotification(int tankPercent) async {
    await _fireStore.collection('users').doc(auth.currentUser.uid).update({
      'send_percent': {'high': null, 'low': tankPercent},
    });
  }

  Future updateSensor(String deviceID) async {
    await _fireStore.collection('users').doc(auth.currentUser.uid).update({
      'sensor': deviceID,
    });
  }

  Future<bool> setAccountsRequiredParameters() async {
    final User currentUser = auth.currentUser;
    DocumentSnapshot snapshot =
        await _fireStore.collection('users').doc(currentUser.uid).get();
    await checkAccountsRequiredParameters();
    if (!snapshot.exists) {
      await _fireStore.collection('users').doc(currentUser.uid).set({
        'first_name': 'null',
        'last_name': 'null',
        'email': currentUser.email,
        'phone': 'null',
        'send_percent': {'high': null, 'low': 15},
        'percent': 10.0,
        'distance': 15,
        'phone_provider': '@tmomail.net',
        'sensor': 'EZSalt_null12',
        'depth': 90,
        'street_address': 'null',
        'city': 'null',
        'state': 'null',
        'zipcode': 10101,
      });
      return false;
    }
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
          if (parameter != 'zipcode' &&
              parameter != 'percent' &&
              parameter != 'distance' &&
              parameter != 'depth' &&
              parameter != 'send_percent' &&
              parameter != 'phone_provider') {
            await _fireStore
                .collection('users')
                .doc(currentUser.uid)
                .update({parameter: 'null'});
            print('missing strings');
          } else if (parameter != 'send_percent' &&
              parameter != 'phone_provider') {
            await _fireStore
                .collection('users')
                .doc(currentUser.uid)
                .update({parameter: 10});
            print('integers');
          } else if (parameter == 'send_percent' &&
              parameter != 'phone_provider') {
            await _fireStore.collection('users').doc(currentUser.uid).update({
              parameter: {'high': null, 'low': 15},
            });
            print('send percent');
          } else if (parameter == 'phone_provider') {
            await _fireStore.collection('users').doc(currentUser.uid).update({
              parameter: '@tmomail.net',
            });
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

  Future<Map> getPhoneProvidersReversed() async {
    Map phoneProvidersReversed = {};
    Map phoneProviders = await getPhoneProviders();
    for (final provider in phoneProviders.keys) {
      phoneProvidersReversed.addAll({phoneProviders[provider]: provider});
    }
    return phoneProvidersReversed;
  }
}
