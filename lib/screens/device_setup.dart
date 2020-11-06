import 'dart:io';

import 'package:ez_salt/components/custom_widgets.dart';
import 'package:ez_salt/constants.dart';
import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class DeviceSetup extends StatefulWidget {
  @override
  _DeviceSetupState createState() => _DeviceSetupState();
}

class _DeviceSetupState extends State<DeviceSetup> {
  Map phoneProviders = {};
  Map phoneProvidersReversed = {};
  double containerHeight;
  String selectedPhoneCarrier;
  String firstName;
  String lastName;
  String phoneNumber;
  String deviceID;
  String zipCode;
  String tankDepth;
  String address;
  String city;
  String state;
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final deviceIdTextController = TextEditingController();

  void getProfileData() async {
    phoneProviders = await AuthService().getPhoneProviders();
    phoneProvidersReversed = await AuthService().getPhoneProvidersReversed();
    setState(() {});
  }

  Widget dropDownBuilder() {
    List<DropdownMenuItem<String>> dropDownItemList = [];

    for (final name in phoneProviders.keys) {
      String phoneCarrier = name;
      String phoneCarrierValue = phoneProviders[name];
      var newDropDownItem = DropdownMenuItem(
        child: Text(phoneCarrier),
        value: phoneCarrierValue,
      );
      dropDownItemList.add(newDropDownItem);
    }
    return Padding(
      padding: const EdgeInsets.only(right: 35, left: 35, top: 5, bottom: 5),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: primaryThemeColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 5, bottom: 5, right: 30, left: 30),
          child: DropdownButton(
            style: TextStyle(
                color: primaryThemeColor, fontWeight: FontWeight.bold),
            value: selectedPhoneCarrier,
            hint: Text(
              'Select Phone Carrier',
              style: TextStyle(color: primaryThemeColor),
            ),
            icon: Icon(Icons.keyboard_arrow_down),
            isExpanded: true,
            underline: Container(),
            items: dropDownItemList,
            onChanged: (value) {
              setState(() {
                selectedPhoneCarrier = value;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget getIosPicker() {
    setState(() {
      containerHeight = 150;
    });
    List<Widget> pickerList = [];
    List<String> phoneCarrierList = [];

    for (final name in phoneProviders.keys) {
      selectedPhoneCarrier = phoneProviders['AT&T'];
      String phoneCarrier = name;
      phoneCarrierList.add(name);
      var pickerItem = Text(phoneCarrier);
      pickerList.add(pickerItem);
    }
    return CupertinoPicker(
        onSelectedItemChanged: (int value) {
          selectedPhoneCarrier = phoneProviders[phoneCarrierList[value]];
        },
        itemExtent: 32.0,
        children: pickerList);
  }

  @override
  void initState() {
    getProfileData();
    dropDownBuilder();
    super.initState();
  }

  void showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  bool assertNoNullFields() {
    if (state != null &&
        city != null &&
        address != null &&
        firstName != null &&
        tankDepth != null &&
        zipCode != null &&
        deviceID != null &&
        lastName != null &&
        phoneNumber != null &&
        selectedPhoneCarrier != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#00FFFFFF', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      deviceIdTextController.text = barcodeScanRes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                text: 'First Name',
                onChanged: (text) => firstName = text.trim(),
              ),
              CustomTextField(
                text: 'Last Name',
                onChanged: (text) => lastName = text.trim(),
              ),
              CustomTextField(
                text: 'Phone Number',
                onChanged: (text) => phoneNumber = text.trim(),
                keyboardType: TextInputType.phone,
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
              CustomTextField(
                text: 'Zip Code',
                keyboardType: TextInputType.number,
                onChanged: (number) => zipCode = number,
              ),
              CustomTextField(
                text: 'Tank Depth cm.',
                keyboardType: TextInputType.number,
                onChanged: (number) => tankDepth = number,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: CustomTextField(
                          horizontalPadding: 5,
                          text: 'Device ID',
                          controller: deviceIdTextController,
                          maxLength: 13,
                          onChanged: (text) => deviceID = text)),
                  GestureDetector(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 17, right: 35),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: primaryThemeColor,
                        size: 40,
                      ),
                    ),
                    onTap: () {
                      scanBarcodeNormal();
                    },
                  )
                ],
              ),
              Container(
                height: containerHeight,
                alignment: Alignment.center,
                child: Platform.isIOS ? getIosPicker() : dropDownBuilder(),
              ),
              //tank depth
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 30),
                child: ReusableOutlineButton(
                  onPressed: () async {
                    if (assertNoNullFields()) {
                      await AuthService().profileAndDeviceSetup(
                          deviceID,
                          address,
                          city,
                          state,
                          int.parse(zipCode),
                          int.parse(tankDepth),
                          firstName,
                          lastName,
                          selectedPhoneCarrier,
                          phoneNumber);
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      showSnackBar('Missing Fields');
                    }
                  },
                  size: 110,
                  icon: Icon(
                    Icons.arrow_forward,
                    size: 0,
                  ),
                  label: Text(
                    'Submit',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ), //Submit button
            ],
          ),
        ),
      ),
    );
  }
}
