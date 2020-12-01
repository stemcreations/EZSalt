import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/foundation.dart';

class ProfileData extends ChangeNotifier {
  AuthService _auth = AuthService();
  Map _profileData = {
    'first_name': '',
    'last_name': '',
    'email': '',
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
  };

  Future<Map> getProfileData() async {
    _profileData = await _auth.getProfile();
    notifyListeners();
    return _profileData;
  }

  Future<void> updateDelivery(bool deliveryEnabled) async {
    await AuthService().updateDeliveryEnabled(deliveryEnabled);
    _profileData['delivery_enabled'] = deliveryEnabled;
    notifyListeners();
  }

  Future<void> updateName(String firstName, String lastName) async {
    await _auth.updateName(firstName, lastName);
    _profileData['first_name'] = firstName;
    _profileData['last_name'] = lastName;
    notifyListeners();
  }

  Future<void> updateEmail(String email) async {
    await _auth.updateEmail(email);
    _profileData['email'] = email;
    notifyListeners();
  }

  String get getFirstName {
    return _profileData['first_name'];
  }

  String get getLastName {
    return _profileData['last_name'];
  }

  bool get getDeliveryEnabled {
    return _profileData['delivery_enabled'];
  }

  String get getEmail {
    return _profileData['email'];
  }
}
