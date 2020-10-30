import 'package:flutter/material.dart';

Color borderAndTextColor = Colors.blue;
Color focusedBorderColor = Colors.blueAccent;
Color backgroundColor = Colors.white;

Map phoneCarriers = {
  'AT&T': '@mms.att.net',
  'T-Mobile': '@tmomail.net',
  'Verizon': '@vtext.com',
  'Sprint': '@page.nextel.com',
  'Virgin Mobile': '@vmobl.com',
  'Tracfone': '@mmst5.tracfone.com',
  'Ting': '@message.ting.com',
  'Boost Mobile': '@myboostmobile.com',
  'U.S. Cellular': '@email.uscc.net',
  'Metro PCS': '@mymetropcs.com',
};

Map phoneCarriersReversed = {
  '@mms.att.net' : 'AT&T',
  '@tmomail.net' : 'T-Mobil',
  '@vtext.com' : 'Verizon',
  '@page.nextel.com': 'Sprint',
  '@vmobl.com' : 'Virgin Mobile',
  '@mmst5.tracfone.com' : 'Tracfone',
  '@message.ting.com' : 'Ting',
  '@myboostmobile.com' : 'Boost Mobile',
  '@email.uscc.net' : 'U.S. Cellular',
  '@mymetropcs.com' : 'Metro PCS',
};