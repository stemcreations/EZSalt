import 'dart:io';

import 'package:ez_salt/components/common_functions.dart';
import 'package:ez_salt/components/custom_widgets.dart';
import 'package:ez_salt/components/profile_data.dart';
import 'package:ez_salt/constants.dart';
import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

//TODO change edit to on long press? and populate text field with current value first

class _ProfilePageState extends State<ProfilePage> {
  Map profileData = {
    'street_address': 'null',
    'distance': 'null',
    'city': 'null',
    'last_name': 'null',
    'zipcode': 0,
    'phone_provider': '@vtext.com',
    'depth': 0,
    'phone': 'null',
    'sensor': 'null',
    'state': 'null',
    'first_name': 'null',
    'email': 'null'
  };
  CommonFunctions commonFunctions = CommonFunctions();
  PersistentBottomSheetController _sheetController;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String emailAddress;
  String firstName = '';
  String lastName = '';
  String phoneNumber;
  String deviceID;
  Map sendPercent = {'high': 'null', 'low': 15};
  Map phoneProviders = {};
  Map phoneProvidersReversed = {};
  final deviceIdTextController = TextEditingController();
  double containerHeight;
  String selectedPhoneCarrier;
  bool editAddress = false;
  bool deliveryAvailable = false;
  bool deliveryEnabled = false;
  bool _isAsyncCall = true;
  String tankDepth;
  String zipCode;
  String tankDepthPercent;
  bool switchVisible = false;

  bool checkIfPhoneProviderIsValid() {
    if (phoneProvidersReversed.containsKey(profileData['phone_provider'])) {
      return true;
    } else {
      return false;
    }
  }

  void showSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  int tankDepthToInt() {
    double tankDepthAsDouble = profileData['depth'] / 2.54;
    int tankDepthAsInt = tankDepthAsDouble.ceil();
    return tankDepthAsInt;
  }

  void getProfileData() async {
    phoneProviders = await AuthService().getPhoneProviders();
    phoneProvidersReversed = await AuthService().getPhoneProvidersReversed();
    profileData = await AuthService().getProfile();
    sendPercent = profileData['send_percent'];
    deliveryEnabled = profileData['delivery_enabled'];

    var zip = profileData['zipcode'];
    zipcodeChangeSwitch(zip);
    setState(() {
      _isAsyncCall = false;
    });
  }

  Future<bool> zipcodeChangeSwitch(zip) async {
    if (zip != null && zip != "") {
      zip = (zip.runtimeType == int) ? zip : int.parse(zip);
      switchVisible = await AuthService()
          .checkDeliveryZipCodes(zip);
    } else {
      switchVisible = false;
    }
    return switchVisible;
  }

  void getPlatform() {
    if (Platform.isIOS) {
      setState(() {
        containerHeight = 150;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    getPlatform();
    getProfileData();
    dropDownBuilder();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    deviceIdTextController.text = Provider.of<ProfileData>(context).getSensorId;
    return _isAsyncCall
        ? Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                ],
              ),
            ),
          )
        : Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              title: Text('Profile'),
              centerTitle: true,
              leading: GestureDetector(
                child: Icon(Icons.arrow_back),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ),
            backgroundColor: backgroundColor,
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'EZsalt',
                        style: TextStyle(
                            fontFamily: 'EZSalt',
                            color: primaryThemeColor,
                            fontSize: 30,
                            fontWeight: FontWeight.w900),
                      ),
                    ),
                    Visibility(
                    visible: switchVisible,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Enable Salt Delivery:',
                            style: TextStyle(
                              color: primaryThemeColor,
                              fontSize: 16,
                            ),
                          ),
                          Switch(
                            value: deliveryEnabled,
                            onChanged: (bool value) async {
                              if (deliveryEnabled == false) {
                                if (profileData['zipcode'] != null) {
                                  bool isDeliveryAvailable = await AuthService()
                                    .checkDeliveryZipCodes(profileData['zipcode']);
                                  Provider.of<ProfileData>(context, listen: false)
                                      .updateDelivery(isDeliveryAvailable);
                                  //If address data doesnt exist go to address setup page
                                  if (profileData['city'] == null) {
                                    await Navigator
                                        .pushReplacementNamed(
                                        context, '/addressSetup');
                                    //if address exists turn on delivery
                                  } else {
                                    deliveryEnabled =
                                        isDeliveryAvailable;
                                  }
                                } else {
                                  _scaffoldKey.currentState.showBottomSheet(
                                        (context) =>
                                        CustomBottomSheet(
                                          context: context,
                                          label:
                                          'See if delivery is available in your area?',
                                          hintText: 'Zip Code',
                                          inputType: TextInputType.number,
                                          onChanged: (value) {
                                            zipCode = value;
                                          },
                                          onPressed: () async {
                                            deliveryAvailable =
                                            await AuthService()
                                                .checkDeliveryZipCodes(
                                                int.parse(zipCode));
                                            if (deliveryAvailable == true) {
                                              Provider.of<ProfileData>(context,
                                                  listen: false)
                                                  .updateDelivery(
                                                  deliveryAvailable);
                                              //If address data doesnt exist go to address setup page
                                              if (profileData['city'] == null) {
                                                await Navigator
                                                    .pushReplacementNamed(
                                                    context, '/addressSetup');
                                                //if address exists turn on delivery
                                              } else {
                                                deliveryEnabled =
                                                    deliveryAvailable;
                                                Navigator.pop(context);
                                              }
                                              //if delivery isnt available update the delivery parameter in the user profile
                                            } else {
                                              await AuthService()
                                                  .updateDeliveryEnabled(
                                                  deliveryAvailable);
                                              commonFunctions.showCustomSnackBar(
                                                  context,
                                                  _scaffoldKey,
                                                  'Delivery Not Available');
                                              //showSnackBar('Delivery Not Available');
                                            }
                                            setState(() {
                                              deliveryEnabled = deliveryAvailable;
                                            });
                                            if (deliveryAvailable == false) {
                                              Navigator.pop(context);
                                            }
                                          },
                                          onCancelPressed: () =>
                                              Navigator.pop(context),
                                        ),
                                    backgroundColor: Colors.transparent,
                                  );
                                }
                              } else {
                                Provider.of<ProfileData>(context, listen: false)
                                    .updateDelivery(value);
                                //AuthService().updateDeliveryEnabled(value);
                                setState(() {
                                  deliveryEnabled = value;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),// Delivery enabled toggle switch
                    CustomProfileCard(
                      onTap: () {
                        _scaffoldKey.currentState.showBottomSheet(
                          (context) => CustomBottomSheet(
                            initialValue: profileData['first_name'] +
                                ' ' +
                                profileData['last_name'],
                            context: context,
                            label: 'Update first and last name',
                            inputType: TextInputType.text,
                            hintText: 'Enter first & last name',
                            onPressed: () async {
                              await AuthService()
                                  .updateName(firstName, lastName);
                              getProfileData();
                              Navigator.of(context).pop();
                              showSnackBar('Profile updated');
                            },
                            onChanged: (value) {
                              String names = value;
                              List tempNames = names.split(' ');
                              firstName = tempNames[0];
                              if (tempNames.length > 1) {
                                lastName = tempNames[1];
                              }
                              print(firstName + lastName);
                            },
                            onCancelPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          backgroundColor: Colors.transparent,
                        );
                        //changeNameDialog(context);
                      },
                      cardData: profileData['first_name'] +
                          ' ' +
                          profileData['last_name'],
                      icon: Icons.person,
                    ), // Names Card
                    deliveryEnabled
                        ? TwoLineCustomCard(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                        title: Text('Edit Address'),
                                        content: Text(
                                            'Are you sure you want to edit your address?'),
                                        actions: [
                                          TextButton(
                                            child: Text('No'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                          TextButton(
                                            child: Text('Yes'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              Navigator.pushReplacementNamed(
                                                  context, '/addressSetup');
                                            },
                                          ),
                                        ],
                                      ));
                              //changeAddressDialog(context);
                            },
                            icon: Icons.location_on,
                            firstLine: (profileData['street_address'] ?? ""),
                            secondLine: (profileData['city'] ?? "") +
                                ' ' +
                                (profileData['state'] ?? "")+
                                ', ' +
                                (profileData['zipcode'] ?? "").toString(),
                          ) // Address Card
                        : SizedBox(),
                    CustomProfileCard(
                      onTap: () {
                        showSnackBar("Updating Email is not allowed");
                      },
                      cardData: profileData['email'],
                      icon: Icons.email,
                    ), //Email Address Card
                    TwoLineCustomCard(
                      onTap: () {
                        _sheetController =
                            _scaffoldKey.currentState.showBottomSheet(
                          (context) => CustomPhoneBottomSheet(
                            initialValue: profileData['phone'],
                            context: context,
                            label: 'Update Phone Number',
                            inputType: TextInputType.number,
                            hintText: 'Phone Number',
                            onPressed: () async {
                              if (phoneNumber != null &&
                                  selectedPhoneCarrier != null) {
                                await AuthService().updatePhone(
                                    phoneNumber, selectedPhoneCarrier);
                                getProfileData();
                                Navigator.of(context).pop();
                                showSnackBar('Phone information updated.');
                              } else {
                                Navigator.of(context).pop();
                                showSnackBar('Missing Data');
                              }
                            },
                            onChanged: (value) {
                              setState(() {
                                phoneNumber = value.trim();
                              });
                            },
                            onCancelPressed: () {
                              Navigator.pop(context);
                            },
                            picker: Platform.isIOS
                                ? getIosPicker()
                                : dropDownBuilder(),
                          ),
                          backgroundColor: Colors.transparent,
                        );
                      },
                      icon: Icons.phone,
                      firstLine: profileData['phone'],
                      secondLine: checkIfPhoneProviderIsValid()
                          ? phoneProvidersReversed[
                              profileData['phone_provider']]
                          : unknownPhoneProvider['unknown'],
                    ),
                    CustomProfileCard(
                      onTap: () {
                        _scaffoldKey.currentState.showBottomSheet(
                              (context) => CustomBottomSheet(
                            initialValue: profileData['zipcode'].toString(),
                            context: context,
                            label: 'Update Zipcode',
                            inputType: TextInputType.number,
                            onPressed: () async {
                              await AuthService()
                                  .updateAddress(null, null, null,
                                  int.parse(zipCode));
                              bool switchVisible = await zipcodeChangeSwitch(zipCode);

                              print("switchVisible: $switchVisible");
                              print("delivery: ${profileData['delivery_enabled']}");
                              print(deliveryEnabled);

                              if (!switchVisible && deliveryEnabled) {
                                showSnackBar("Zipcode Updated, Salt Delivery Turned Off (Zipcode Out of Range)");
                                await AuthService().updateDeliveryEnabled(false);
                              } else {
                                showSnackBar('Zipcode Updated');
                              }

                              // Leave this below snackbar
                              getProfileData();
                              Navigator.of(context).pop();
                            },
                            onChanged: (value) {
                              setState(() {
                                zipCode = value;
                              });
                            },
                            onCancelPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          backgroundColor: Colors.transparent,
                        );
                        //changeTankDepthDialog(context);
                      },
                      cardData:
                      'Zipcode: ' + profileData['zipcode'].toString(),
                      icon: Icons.add_location,
                    ), // Tank
                    CustomProfileCard(
                      onTap: () {
                        _scaffoldKey.currentState.showBottomSheet(
                          (context) => CustomBottomSheet(
                            initialValue: tankDepthToInt().toString(),
                            context: context,
                            label: 'Update Tank Depth',
                            inputType: TextInputType.number,
                            hintText: 'Tank Depth in inches',
                            onPressed: () async {
                              double tankDepthDouble =
                                  double.parse(tankDepth) * 2.54;
                              await AuthService()
                                  .updateTankDepth(tankDepthDouble.floor());
                              getProfileData();
                              showSnackBar('Tank Depth Updated');
                              Navigator.of(context).pop();
                            },
                            onChanged: (value) {
                              setState(() {
                                tankDepth = value;
                              });
                            },
                            onCancelPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          backgroundColor: Colors.transparent,
                        );
                        //changeTankDepthDialog(context);
                      },
                      cardData:
                          'Tank Depth: ' + tankDepthToInt().toString() + 'in',
                      icon: Icons.delete_outline,
                    ), // Tank Depth Card
                    CustomProfileCard(
                      onTap: () {
                        _scaffoldKey.currentState.showBottomSheet(
                          (context) => CustomBottomSheetWithCamera(
                            initialValue: profileData['sensor'],
                            context: context,
                            label: 'Update Device ID',
                            inputType: TextInputType.text,
                            hintText: 'Enter Device ID',
                            onPressed: () async {
                              await AuthService().updateSensor(deviceID);
                              getProfileData();
                              Navigator.of(context).pop();
                              showSnackBar('Device Id Updated');
                            },
                            onChanged: (value) {
                              setState(() {
                                deviceID = value;
                              });
                            },
                            onCancelPressed: () {
                              Navigator.pop(context);
                            },
                            onTap: () async {
                              deviceID = await scanBarcodeNormal();
                              await AuthService().updateSensor(deviceID);
                              getProfileData();
                              Navigator.of(context).pop();
                              showSnackBar('Device Id Updated');
                            },
                          ),
                          backgroundColor: Colors.transparent,
                        );
                        //changeSensorDialog(context);
                      },
                      cardData: profileData['sensor'],
                      icon: Icons.developer_board,
                    ), // Device ID Card
                    CustomProfileCard(
                      onTap: () {
                        _scaffoldKey.currentState.showBottomSheet(
                          (context) => CustomBottomSheet(
                            initialValue: sendPercent['low'].toString(),
                            context: context,
                            label:
                                'Change when you receive low salt notifications.',
                            hintText: 'Notification depth %',
                            onPressed: () async {
                              await AuthService().updateTankDepthNotification(
                                  int.parse(tankDepthPercent));
                              getProfileData();
                              showSnackBar('Notification depth changed');
                              Navigator.pop(context);
                            },
                            onChanged: (percent) async {
                              setState(() {
                                tankDepthPercent = percent;
                              });
                            },
                            onCancelPressed: () => Navigator.pop(context),
                            inputType: TextInputType.number,
                          ),
                          backgroundColor: Colors.transparent,
                        );
                        //changeTankNotificationDepthDialog(context);
                      },
                      cardData: 'Tank depth notification = ' +
                          sendPercent['low'].toString() +
                          '%',
                      icon: Icons.delete_outline,
                    ), // Notification Depth Card

                    SizedBox(height: 75.0)
                  ],
                ),
              ),
            ),
          );
  }

  Future<String> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#00FFFFFF', 'Cancel', true, ScanMode.BARCODE);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return null;
    setState(() {
      deviceIdTextController.text = barcodeScanRes;
    });
    return barcodeScanRes;
  }

  Widget dropDownBuilder() {
    getProfileData();

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
              color: primaryThemeColor,
              fontWeight: FontWeight.bold,
            ),
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
                _sheetController.setState(() {
                  selectedPhoneCarrier = value;
                });
              });
            },
          ),
        ),
      ),
    );
  }

  Widget getIosPicker() {
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
          setState(() {
            selectedPhoneCarrier = phoneProviders[phoneCarrierList[value]];
          });
        },
        itemExtent: 32.0,
        children: pickerList);
  }
}
