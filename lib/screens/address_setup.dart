import 'package:ez_salt/components/custom_widgets.dart';
import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class AddressSetup extends StatefulWidget {
  @override
  _AddressSetupState createState() => _AddressSetupState();
}

class _AddressSetupState extends State<AddressSetup> {
  String address;
  String city;
  // String zipCode;
  String state;
  Map profileData = {};

  void getProfileData() async {
    profileData = await AuthService().getProfile();
  }

  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(state);
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Profile Setup'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Text(
                  'EZsalt',
                  style: TextStyle(
                    fontFamily: 'EZSalt',
                    color: primaryThemeColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              CustomTextField(
                text: 'Street Address',
                onChanged: (text) => address = text.trim(),
              ),
              CustomTextField(
                text: 'City',
                onChanged: (text) => city = text,
              ),
              CustomTextField(
                text: 'State',
                onChanged: (text) => state = text,
              ),
              // CustomTextField(
              //   text: 'Zip Code',
              //   keyboardType: TextInputType.number,
              //   onChanged: (number) => zipCode = number,
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ReusableOutlineButton(
                        icon: Icon(
                          Icons.add,
                          size: 0,
                        ),
                        label: Text('Cancel'),
                        onPressed: () async {
                          if (profileData['delivery_enabled'] == true &&
                              profileData['street_address'] != null &&
                              profileData['city'] != null &&
                              profileData['state'] != null &&
                              profileData['zipcode'] != null) {
                            Navigator.pushReplacementNamed(context, '/profile');
                          } else {
                            await AuthService().updateDeliveryEnabled(false);
                            Navigator.pushReplacementNamed(context, '/profile');
                          }
                        },
                        size: 100),
                    SizedBox(
                      width: 15,
                    ),
                    ReusableOutlineButton(
                      size: 100,
                      onPressed: () async {
                        await AuthService().updateAddress(
                            address, city, state, null); //int.parse(zipCode));
                        Navigator.pushReplacementNamed(context, '/profile');
                      },
                      label: Text('Submit'),
                      icon: Icon(
                        Icons.add,
                        size: 0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
