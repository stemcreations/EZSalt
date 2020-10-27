import 'dart:io';

import 'package:ez_salt/networking/authentication.dart';
import 'package:ez_salt/components/custom_widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ez_salt/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Map profileData = {'street_address': 'null', 'distance': 'null', 'city': 'null',
  'last_name': 'null', 'zipcode': 0, 'phone_provider': '@vtext.com', 'depth': 0,
  'phone': 'null', 'sensor': 'null', 'state': 'null', 'first_name': 'null', 'email': 'null'};
  final deviceIdTextController = TextEditingController();
  double containerHeight;
  String selectedPhoneCarrier;
  bool enterEditMode = false;
  bool editAddress = false;

  void getProfileData() async {
    profileData = await AuthService().getProfile();
    setState(() {});
  }

  void getPlatform(){
    if(Platform.isIOS){
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
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
              child: Icon(Icons.edit),
              onTap: (){ setState(() {
                if(enterEditMode){
                  enterEditMode = false;
                }else{
                  enterEditMode = true;
                }
              });},
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
                child: Text('EZSalt', style: TextStyle(
                  fontFamily: 'EZSalt',
                  color: borderAndTextColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w900
                ),),
              ),
              CustomProfileCard(onTap: (){changeNameDialog(context);},enterEditMode: enterEditMode, cardData: profileData['first_name'] + ' ' + profileData['last_name'], icon: Icon(Icons.person, color: Colors.grey.shade600,),),
              TwoLineCustomCard(onTap: (){changeAddressDialog(context);},enterEditMode: enterEditMode, icon: Icons.location_on, firstLine: profileData['street_address'], secondLine: profileData['city'] + ' ' + profileData['state'] + ', ' + profileData['zipcode'].toString(),),
              CustomProfileCard(onTap: (){changeEmailDialog(context);}, enterEditMode: enterEditMode, cardData: profileData['email'], icon: Icon(Icons.email, color: Colors.grey.shade600,),),
              TwoLineCustomCard(onTap: (){changePhoneInformation(context);}, enterEditMode: enterEditMode, icon: Icons.phone, firstLine: profileData['phone'], secondLine: phoneCarriersReversed[profileData['phone_provider']],),
              CustomProfileCard(onTap: (){changeTankDepthDialog(context);}, enterEditMode: enterEditMode, cardData: 'Tank Depth: ' + profileData['depth'].toString() + 'cm', icon: Icon(Icons.delete_outline, color: Colors.grey.shade600,),),
              CustomProfileCard(onTap: (){changeSensorDialog(context);}, enterEditMode: enterEditMode, cardData: profileData['sensor'], icon: Icon(Icons.developer_board, color: Colors.grey.shade600,),),
            ],
          ),
        ),
      ),
    );
  }

  void changeNameDialog(BuildContext context){
    String firstName = '';
    String lastName = '';
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Center(
            child: Dialog(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 2.5,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: new BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(padding: const EdgeInsets.only(top: 20), child: Text('Update Name', style: TextStyle(fontSize: 20, color: borderAndTextColor),),),
                            Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: CustomTextField(text: 'First Name', autoFocus: true, onChanged: (String value) { setState(() {
                                  firstName = value.trim();
                                });},)
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 20),
                                child: CustomTextField(text: 'Last Name', autoFocus: true, onChanged: (String value) { setState(() {
                                  lastName = value.trim();
                                });},)
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: MaterialButton(
                            minWidth: 120,
                            elevation: 3,
                            color: Colors.grey.shade300,
                            textColor: borderAndTextColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                            onPressed: () async {
                              await AuthService().updateName(firstName, lastName);
                              getProfileData();
                              Navigator.of(context).pop();
                            },
                            child: Text('Submit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  void changePhoneInformation(BuildContext context) {
    String phoneNumber;
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Center(
            child: Dialog(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 2.5,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: new BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(padding: const EdgeInsets.only(top: 20), child: Text('Update Phone Number', style: TextStyle(fontSize: 20, color: borderAndTextColor),),),
                            Container(
                              height: containerHeight,
                              alignment: Alignment.center,
                              child: Platform.isIOS ? getIosPicker() : dropDownBuilder(),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: CustomTextField(text: 'Phone Number', autoFocus: true, onChanged: (String value) { setState(() {
                                  phoneNumber = value.trim();
                                });},)
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: MaterialButton(
                            minWidth: 120,
                            elevation: 3,
                            color: Colors.grey.shade300,
                            textColor: borderAndTextColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                            onPressed: () async {
                              await AuthService().updatePhone(phoneNumber, selectedPhoneCarrier);
                              getProfileData();
                              Navigator.of(context).pop();
                            },
                            child: Text('Submit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  void changeAddressDialog(BuildContext context){
    String streetAddress;
    String city;
    String state;
    String zipCode;
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Center(
            child: Dialog(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 1,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: new BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(padding: const EdgeInsets.only(top: 10), child: Text('Update Address', style: TextStyle(fontSize: 20, color: borderAndTextColor),),),
                            Padding(
                                padding: const EdgeInsets.only(top: 2.5),
                                child: CustomTextField(text: 'Street Address', autoFocus: true, onChanged: (value){
                                  streetAddress = value;
                                },)
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 2.5),
                                child: CustomTextField(text: 'City', autoFocus: true, onChanged: (value){
                                  city = value;
                                },)
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 2.5),
                                child: CustomTextField(text: 'State', autoFocus: true, onChanged: (value){
                                  state = value;
                                },)
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 2.5, bottom: 10),
                                child: CustomTextField(text: 'Zip Code', autoFocus: true,keyboardType: TextInputType.number, onChanged: (value){
                                  zipCode = value;
                                },)
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: MaterialButton(
                            minWidth: 120,
                            elevation: 3,
                            color: Colors.grey.shade300,
                            textColor: borderAndTextColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                            onPressed: () async {
                              await AuthService().updateAddress(streetAddress, city, state, int.parse(zipCode));
                              getProfileData();
                              Navigator.of(context).pop();
                            },
                            child: Text('Submit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  void changeEmailDialog(BuildContext context){
    String email;
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Center(
            child: Dialog(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 2.5,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: new BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(padding: const EdgeInsets.only(top: 20), child: Text('Update Email', style: TextStyle(fontSize: 20, color: borderAndTextColor),),),
                            Padding(
                                padding: const EdgeInsets.only(top: 10.0, bottom: 40),
                                child: CustomTextField(text: 'Email Address', autoFocus: true, onChanged: (String value) { setState(() {
                                  email = value.trim();
                                });},)
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: MaterialButton(
                            minWidth: 120,
                            elevation: 3,
                            color: Colors.grey.shade300,
                            textColor: borderAndTextColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                            onPressed: () async {
                              await AuthService().updateEmail(email);
                              getProfileData();
                              Navigator.of(context).pop();
                            },
                            child: Text('Submit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  void changeTankDepthDialog(BuildContext context){
    String tankDepth;
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Center(
            child: Dialog(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 2.5,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: new BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(padding: const EdgeInsets.only(top: 20), child: Text('Update Tank Depth', style: TextStyle(fontSize: 20, color: borderAndTextColor),),),
                            Padding(
                                padding: const EdgeInsets.only(top: 10.0, bottom: 40),
                                child: CustomTextField(text: 'Tank Depth', autoFocus: true, keyboardType: TextInputType.number, onChanged: (String value) { setState(() {
                                  tankDepth = value.trim();
                                });},)
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: MaterialButton(
                            minWidth: 120,
                            elevation: 3,
                            color: Colors.grey.shade300,
                            textColor: borderAndTextColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                            onPressed: () async {
                              await AuthService().updateTankDepth(int.parse(tankDepth));
                              getProfileData();
                              Navigator.of(context).pop();
                            },
                            child: Text('Submit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  void changeSensorDialog(BuildContext context){
    String deviceID;
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Center(
            child: Dialog(
              child: SizedBox(
                width: MediaQuery.of(context).size.width / 1,
                height: MediaQuery.of(context).size.height / 2.5,
                child: SingleChildScrollView(
                  child: Container(
                    decoration: new BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.white),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Padding(padding: const EdgeInsets.only(top: 20), child: Text('Update Sensor ID', style: TextStyle(fontSize: 20, color: borderAndTextColor),),),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(child: CustomTextField(horizontalPadding: 5, text: 'Device ID', controller: deviceIdTextController, maxLength: 13, onChanged: (text) => deviceID = text)),
                                GestureDetector(child: Padding(
                                  padding: const EdgeInsets.only(bottom: 17, right: 35),
                                  child: Icon(Icons.camera_alt_outlined, color: borderAndTextColor, size: 40,),
                                ), onTap: (){
                                  scanBarcodeNormal();
                                },)
                              ],
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: MaterialButton(
                            minWidth: 120,
                            elevation: 3,
                            color: Colors.grey.shade300,
                            textColor: borderAndTextColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0),),
                            onPressed: () async {
                              await AuthService().updateSensor(deviceID);
                              getProfileData();
                              Navigator.of(context).pop();
                            },
                            child: Text('Submit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#00FFFFFF', 'Cancel', true, ScanMode.BARCODE);
    }on PlatformException{
      barcodeScanRes = 'Failed to get platform version.';
    }
    if(!mounted) return;
    setState(() {
      deviceIdTextController.text = barcodeScanRes;
    });
  }

  Widget dropDownBuilder(){

    List<DropdownMenuItem<String>> dropDownItemList = [];

    for(final name in phoneCarriers.keys){
      String phoneCarrier = name;
      String phoneCarrierValue = phoneCarriers[name];
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
          border: Border.all(color: borderAndTextColor), borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 5, bottom: 5, right: 30, left: 30),
          child: DropdownButton(
            style: TextStyle(color: borderAndTextColor, fontWeight: FontWeight.bold),
            value: selectedPhoneCarrier,
            hint: Text('Select Phone Carrier', style: TextStyle(color: borderAndTextColor),),
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

  Widget getIosPicker(){
    List<Widget> pickerList = [];
    List<String> phoneCarrierList = [];

    for(final name in phoneCarriers.keys){
      selectedPhoneCarrier = phoneCarriers['AT&T'];
      String phoneCarrier = name;
      phoneCarrierList.add(name);
      var pickerItem = Text(phoneCarrier);
      pickerList.add(pickerItem);
    }
    return CupertinoPicker(
        onSelectedItemChanged: (int value) { setState(() {
          selectedPhoneCarrier = phoneCarriers[phoneCarrierList[value]];
        });},
        itemExtent: 32.0,
        children: pickerList);

  }

}
