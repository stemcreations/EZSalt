import 'package:flutter/material.dart';

Color primaryThemeColor = Colors.blue;
Color focusedBorderColor = Colors.blueAccent;
Color backgroundColor = Colors.white;
Color profileScreenTextColor = Colors.grey.shade600;

List newProfileSetupData;

Map unknownPhoneProvider = {
  'unknown': 'unknown',
};

List<String> requiredAccountParameters = [
  'first_name',
  'last_name',
  'email',
  'phone',
  'send_percent',
  'percent',
  'distance',
  'phone_provider',
  'sensor',
  'depth',
  'street_address',
  'city',
  'state',
  'zipcode',
  'delivery_enabled',
  'temp_percent'
];
