import 'dart:io';

import 'package:ez_salt/components/custom_widgets.dart';
import 'package:ez_salt/constants.dart';
import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

//TODO use bottom sheet instead of popup dialog
//TODO ask user if they want salt delivery and ask for zipCode
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map sendPercent = {'high': 'null', 'low': 15};
  Map phoneProviders = {};
  Map phoneProvidersReversed = {};
  final deviceIdTextController = TextEditingController();
  double containerHeight;
  String selectedPhoneCarrier;
  bool enterEditMode = false;
  bool editAddress = false;
  bool deliveryAvailable = false;
  bool deliveryEnabled = false; //TODO make this a variable inside each profile
  String zipCode;

  bool checkIfPhoneProviderIsValid() {
    if (phoneProvidersReversed.containsKey(profileData['phone_provider'])) {
      return true;
    } else {
      return false;
    }
  }

  void getProfileData() async {
    phoneProviders = await AuthService().getPhoneProviders();
    phoneProvidersReversed = await AuthService().getPhoneProvidersReversed();
    profileData = await AuthService().getProfile();
    sendPercent = profileData['send_percent'];
    deliveryEnabled = profileData['delivery_enabled'];
    setState(() {});
  }

  void getPlatform() {
    if (Platform.isIOS) {
      setState(() {
        containerHeight = 150;
      });
    }
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              child: Icon(Icons.edit),
              onTap: () {
                setState(() {
                  if (enterEditMode) {
                    enterEditMode = false;
                  } else {
                    enterEditMode = true;
                  }
                });
              },
            ),
          )
        ],
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
              Row(
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
                    onChanged: (bool value) {
                      if (deliveryEnabled == false) {
                        _scaffoldKey.currentState.showBottomSheet(
                          (context) => CustomBottomSheet(
                            context: context,
                            label: 'See if delivery is available in your area?',
                            hintText: 'Zip Code',
                            inputType: TextInputType.number,
                            onChanged: (value) {
                              zipCode = value;
                            },
                            onPressed: () async {
                              deliveryAvailable = await AuthService()
                                  .checkDeliveryZipCodes(int.parse(zipCode));
                              if (deliveryAvailable == true) {
                                await AuthService()
                                    .updateDeliveryEnabled(deliveryAvailable);
                                //Check to see if the user already has address info in their profile and if so just enable delivery
                                if (profileData['city'] == null) {
                                  await Navigator.pushReplacementNamed(
                                      context, '/addressSetup');
                                } else {
                                  deliveryEnabled = deliveryAvailable;
                                  Navigator.pop(context);
                                }
                              } else {
                                await AuthService()
                                    .updateDeliveryEnabled(deliveryAvailable);
                                Navigator.pop(context);
                              }
                              setState(() {
                                deliveryEnabled = deliveryAvailable;
                              });
                              if (deliveryAvailable == false) {
                                Navigator.pop(context);
                              }
                            },
                            onCancelPressed: () => Navigator.pop(context),
                          ),
                        );
                      } else {
                        AuthService().updateDeliveryEnabled(value);
                        setState(() {
                          deliveryEnabled = value;
                        });
                      }
                    },
                  ),
                ],
              ),
              CustomProfileCard(
                onTap: () {
                  changeNameDialog(context);
                },
                enterEditMode: enterEditMode,
                cardData:
                    profileData['first_name'] + ' ' + profileData['last_name'],
                icon: Icon(
                  Icons.person,
                  color: Colors.grey.shade600,
                ),
              ),
              deliveryEnabled
                  ? TwoLineCustomCard(
                      onTap: () {
                        changeAddressDialog(context);
                      },
                      enterEditMode: enterEditMode,
                      icon: Icons.location_on,
                      firstLine: profileData['street_address'],
                      secondLine: profileData['city'] +
                          ' ' +
                          profileData['state'] +
                          ', ' +
                          profileData['zipcode'].toString(),
                    )
                  : SizedBox(),
              CustomProfileCard(
                onTap: () {
                  changeEmailDialog(context);
                },
                enterEditMode: enterEditMode,
                cardData: profileData['email'],
                icon: Icon(
                  Icons.email,
                  color: Colors.grey.shade600,
                ),
              ),
              TwoLineCustomCard(
                onTap: () {
                  changePhoneInformation(context);
                },
                enterEditMode: enterEditMode,
                icon: Icons.phone,
                firstLine: profileData['phone'],
                secondLine: checkIfPhoneProviderIsValid()
                    ? phoneProvidersReversed[profileData['phone_provider']]
                    : unknownPhoneProvider['unknown'],
              ),
              CustomProfileCard(
                onTap: () {
                  changeTankDepthDialog(context);
                },
                enterEditMode: enterEditMode,
                cardData:
                    'Tank Depth: ' + profileData['depth'].toString() + 'cm',
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.grey.shade600,
                ),
              ),
              CustomProfileCard(
                onTap: () {
                  changeSensorDialog(context);
                },
                enterEditMode: enterEditMode,
                cardData: profileData['sensor'],
                icon: Icon(
                  Icons.developer_board,
                  color: Colors.grey.shade600,
                ),
              ),
              CustomProfileCard(
                onTap: () {
                  changeTankNotificationDepthDialog(context);
                },
                enterEditMode: enterEditMode,
                cardData: 'Tank depth notification = ' +
                    sendPercent['low'].toString() +
                    '%',
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeNameDialog(BuildContext context) {
    String firstName = '';
    String lastName = '';
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Dialog(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 2.5,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                'Update Name',
                                style: TextStyle(
                                    fontSize: 20, color: primaryThemeColor),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: CustomTextField(
                                  text: 'First Name',
                                  autoFocus: true,
                                  onChanged: (String value) {
                                    setState(() {
                                      firstName = value.trim();
                                    });
                                  },
                                )),
                            Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, bottom: 20),
                                child: CustomTextField(
                                  text: 'Last Name',
                                  autoFocus: true,
                                  onChanged: (String value) {
                                    setState(() {
                                      lastName = value.trim();
                                    });
                                  },
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: ReusableOutlineButton(
                            icon: Icon(
                              Icons.add,
                              size: 0,
                            ),
                            label: Text('Submit'),
                            size: 120,
                            onPressed: () async {
                              await AuthService()
                                  .updateName(firstName, lastName);
                              getProfileData();
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void changePhoneInformation(BuildContext context) {
    String phoneNumber;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Dialog(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 2.5,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                'Update Phone Number',
                                style: TextStyle(
                                    fontSize: 20, color: primaryThemeColor),
                              ),
                            ),
                            Container(
                              height: containerHeight,
                              alignment: Alignment.center,
                              child: Platform.isIOS
                                  ? getIosPicker()
                                  : dropDownBuilder(),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: CustomTextField(
                                  text: 'Phone Number',
                                  keyboardType: TextInputType.number,
                                  autoFocus: true,
                                  onChanged: (String value) {
                                    setState(() {
                                      phoneNumber = value.trim();
                                    });
                                  },
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 80.0),
                          child: ReusableOutlineButton(
                            icon: Icon(
                              Icons.add,
                              size: 0,
                            ),
                            label: Text('Submit'),
                            size: 120,
                            onPressed: () async {
                              await AuthService().updatePhone(
                                  phoneNumber, selectedPhoneCarrier);
                              getProfileData();
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void changeAddressDialog(BuildContext context) {
    String streetAddress;
    String city;
    String state;
    String zipCode;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Dialog(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 1.9,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            'Update Address',
                            style: TextStyle(
                                fontSize: 20, color: primaryThemeColor),
                          ),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(top: 2.5),
                            child: CustomTextField(
                              text: 'Street Address',
                              autoFocus: true,
                              onChanged: (value) {
                                streetAddress = value;
                              },
                            )),
                        Padding(
                            padding: const EdgeInsets.only(top: 2.5),
                            child: CustomTextField(
                              text: 'City',
                              autoFocus: true,
                              onChanged: (value) {
                                city = value;
                              },
                            )),
                        Padding(
                            padding: const EdgeInsets.only(top: 2.5),
                            child: CustomTextField(
                              text: 'State',
                              autoFocus: true,
                              onChanged: (value) {
                                state = value;
                              },
                            )),
                        Padding(
                            padding:
                                const EdgeInsets.only(top: 2.5, bottom: 10),
                            child: CustomTextField(
                              text: 'Zip Code',
                              autoFocus: true,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                zipCode = value;
                              },
                            )),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ReusableOutlineButton(
                            onPressed: () async {
                              await AuthService().updateAddress(streetAddress,
                                  city, state, int.parse(zipCode));
                              getProfileData();
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.add,
                              size: 0,
                            ),
                            label: Text('Submit'),
                            size: 120,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void changeEmailDialog(BuildContext context) {
    String email;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Dialog(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 2.5,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                'Update Email',
                                style: TextStyle(
                                    fontSize: 20, color: primaryThemeColor),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 40),
                                child: CustomTextField(
                                  text: 'Email Address',
                                  autoFocus: true,
                                  onChanged: (String value) {
                                    setState(() {
                                      email = value.trim();
                                    });
                                  },
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 80.0),
                          child: ReusableOutlineButton(
                            icon: Icon(
                              Icons.add,
                              size: 0,
                            ),
                            label: Text('Submit'),
                            size: 120,
                            onPressed: () async {
                              await AuthService().updateEmail(email);
                              getProfileData();
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void changeTankDepthDialog(BuildContext context) {
    String tankDepth;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Dialog(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 2.5,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                'Update Tank Depth',
                                style: TextStyle(
                                    fontSize: 20, color: primaryThemeColor),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 40),
                                child: CustomTextField(
                                  text: 'Tank Depth',
                                  autoFocus: true,
                                  keyboardType: TextInputType.number,
                                  onChanged: (String value) {
                                    setState(() {
                                      tankDepth = value.trim();
                                    });
                                  },
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: ReusableOutlineButton(
                            icon: Icon(
                              Icons.add,
                              size: 0,
                            ),
                            label: Text('Submit'),
                            size: 120,
                            onPressed: () async {
                              await AuthService()
                                  .updateTankDepth(int.parse(tankDepth));
                              getProfileData();
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void changeTankNotificationDepthDialog(BuildContext context) {
    String tankDepthPercent;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Dialog(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 2.5,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                'Update Tank Depth Notification',
                                style: TextStyle(
                                    fontSize: 18, color: primaryThemeColor),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 40),
                                child: CustomTextField(
                                  text: 'Tank Notification Depth',
                                  autoFocus: true,
                                  keyboardType: TextInputType.number,
                                  onChanged: (String value) {
                                    setState(() {
                                      tankDepthPercent = value.trim();
                                    });
                                  },
                                )),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: ReusableOutlineButton(
                            icon: Icon(
                              Icons.add,
                              size: 0,
                            ),
                            label: Text('Submit'),
                            size: 120,
                            onPressed: () async {
                              await AuthService().updateTankDepthNotification(
                                  int.parse(tankDepthPercent));
                              getProfileData();
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void changeSensorDialog(BuildContext context) {
    String deviceID;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Dialog(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 2.5,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Text(
                                'Update Sensor ID',
                                style: TextStyle(
                                    fontSize: 20, color: primaryThemeColor),
                              ),
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
                                    padding: const EdgeInsets.only(
                                        bottom: 17, right: 35),
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
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: ReusableOutlineButton(
                            icon: Icon(
                              Icons.add,
                              size: 0,
                            ),
                            label: Text('Submit'),
                            size: 120,
                            onPressed: () async {
                              await AuthService().updateSensor(deviceID);
                              getProfileData();
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
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
