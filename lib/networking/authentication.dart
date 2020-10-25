import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  UserCredential  currentUser;
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();

  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential = await auth.signInWithCredential(credential);
    final User user = userCredential.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);
    final User currentUser = auth.currentUser;
    assert(user.uid == currentUser.uid);

    DocumentSnapshot snapshot = await _fireStore.collection('users').doc(currentUser.uid).get();


    //This Section works but i need to send them to the profile setup page after
    // selecting google signin if they dont already have an account
    //
    if(!snapshot.exists){
      await _fireStore.collection('users').doc(currentUser.uid).set({
        'first_name': 'null',
        'last_name': 'null',
        'email': currentUser.email,
        'phone': 'null',
        'send_percent':{'high': null, 'low': 15},
        'percent': 88.0,
        'distance': 15,
        'phone_provider': '@page.nextell.com',
        'sensor': 'EZSalt_null12',
        'depth': 90,
        'street_address': 'null',
        'city': 'null',
        'state': 'null',
        'zipcode': 10101,
      });
      return 'new user created';
    }

    return 'signInWithGoogle succeeded';
  }

  void printUid(){

    print(auth.currentUser.uid);

  }

  void signOutGoogle() async {
    await auth.signOut();
    await googleSignIn.signOut();
  }

  Future createUserWithEmailAndPassword(String email, String password) async {

    UserCredential user = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
    _fireStore.collection('users').doc(user.user.uid).set({
      'first_name': 'null',
      'last_name': 'null',
      'email': email,
      'phone': 'null',
      'send_percent':{'high': null, 'low': 15},
      'percent': 88.0,
      'distance': 15,
      'phone_provider': 'null',
      'sensor': 'Set Device ID',
      'depth': 20,
      'street_address': 'null',
      'city': 'null',
      'state': 'null',
      'zipcode': 'null',
    });
  }

  Future profileAndDeviceSetup(
      String deviceID, String address, String city, String state,
      int zipCode, int tankDepth, firstName, lastName, phoneProvider, phoneNumber) async {

    _fireStore.collection('users').doc(auth.currentUser.uid).update({
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

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
      currentUser = await auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      if(currentUser != null) {
        return currentUser;
      }else{
        return null;
      }
  }

  //TODO add functionality to push a refresh on the sensor via API... I don't know if API currently exists to do this.
  Future getTankLevel() async {
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

  Future<String> resetPassword(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      return 'success';
    } catch (error) {
      print(error);
      return error;
    }
  }
}

