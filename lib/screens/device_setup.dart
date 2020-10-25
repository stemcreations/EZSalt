import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/material.dart';
import 'package:ez_salt/components/custom_widgets.dart';
import 'package:ez_salt/constants.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class DeviceSetup extends StatefulWidget {
  @override
  _DeviceSetupState createState() => _DeviceSetupState();
}

class _DeviceSetupState extends State<DeviceSetup> {
  String deviceID;
  String zipCode;
  String tankDepth;
  String address;
  String city;
  String state;
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final deviceIdTextController = TextEditingController();

  void showSnackBar(String message){
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message),));
  }

  bool assertNoNullFields(){
    if(state != null && city != null && address != null
        && tankDepth != null && zipCode != null && deviceID != null
    ){
      return true;
    }else {
      return false;
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
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
                  'EZSalt',
                  style: TextStyle(
                    fontFamily: 'EZSalt',
                    color: borderAndTextColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              CustomTextField(text: 'Street Address', onChanged: (text) => address = text.trim(),),
              CustomTextField(text: 'City', onChanged: (text) => city = text,),
              CustomTextField(text: 'State', onChanged: (text) => state = text,),
              CustomTextField(text: 'Zip Code', keyboardType: TextInputType.number, onChanged: (number) => zipCode = number,),
              CustomTextField(text: 'Tank Depth cm.', keyboardType: TextInputType.number, onChanged: (number) => tankDepth = number,),
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
              ),//tank depth
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 20),
                child: MaterialButton(
                  onPressed: () async {
                    if(assertNoNullFields()) {
                      await AuthService().profileAndDeviceSetup(
                          deviceID,
                          address,
                          city,
                          state,
                          int.parse(zipCode),
                          int.parse(tankDepth)
                      );
                      //TODO fix form reset;
                      //formKey.currentState.reset();
                      Navigator.pushNamed(context, '/home');
                    }else{
                      showSnackBar('Missing Fields');
                    }
                  },
                  child: Text('Submit', style: TextStyle(color: borderAndTextColor),),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  color: Colors.grey.shade300,
                  elevation: 3,
                ),
              ), //Submit button
            ],
          ),
        ),
      ),
    );
  }
}

