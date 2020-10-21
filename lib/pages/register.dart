import 'package:ez_salt/components/custom_widgets.dart';
import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/material.dart';
import 'package:ez_salt/constants.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String selectedPhoneCarrier;
  String firstName;
  String lastName;
  String email;
  String password;
  String confirmedPassword;
  String address;
  String city;
  String state;
  String phoneNumber;
  String deviceID;
  String zipCode;
  String tankDepth;
  bool passwordsMatch;

  List<DropdownMenuItem> dropDownBuilder(){
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
    return dropDownItemList;
  }

  bool assertNoNullFields(){
    if(selectedPhoneCarrier != null && firstName != null && lastName != null
        && email != null && passwordsMatch != false && address != null && city != null
        && state != null && zipCode != null && phoneNumber != null && deviceID != null
        && tankDepth != null
    ){
      return true;
    }else {
      return false;
    }
  }

  void checkPasswordMatch(){
    if(password == confirmedPassword){
      setState(() {
        passwordsMatch = true;
        print('passwords match');
      });
    }else{
      setState(() {
        passwordsMatch = false;
        print('passwords dont match');
      });
    }
  }

  @override
  void initState() {
    dropDownBuilder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Register'),
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
              CustomTextField(text: 'First Name', onChanged: (text) => firstName = text.trim(),),
              CustomTextField(text: 'Last Name', onChanged: (text) => lastName = text.trim(),),
              CustomTextField(text: 'Phone Number', onChanged: (text) => phoneNumber = text.trim(), keyboardType: TextInputType.phone,),
              CustomTextField(text: 'Email Address', onChanged: (text) => email = text.trim(),), //email / username
              CustomTextField(text: 'Password', obscureText: true, onChanged: (text) => password = text.trim(),), //password
              CustomTextField(text: 'Confirm Password', obscureText: true, onChanged: (text){
                confirmedPassword = text;
                checkPasswordMatch();
              },), //re-enter password
              CustomTextField(text: 'Tank Depth In cm.', keyboardType: TextInputType.number, onChanged: (number) => tankDepth = number,),
              CustomTextField(text: 'Street Address', onChanged: (text) => address = text.trim(),),
              CustomTextField(text: 'City', onChanged: (text) => city = text,),
              CustomTextField(text: 'State', onChanged: (text) => state = text,),
              CustomTextField(text: 'Zip Code', keyboardType: TextInputType.number, onChanged: (number) => zipCode = number,),
              CustomTextField(text: 'Device ID', maxLength: 13, onChanged: (text) => deviceID = text,),//tank depth
              DropdownButton(
                style: TextStyle(color: borderAndTextColor, fontWeight: FontWeight.bold),
                value: selectedPhoneCarrier,
                hint: Text('Select Phone Carrier'),
                items: dropDownBuilder(),
                onChanged: (value) {
                  setState(() {
                    selectedPhoneCarrier = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 20),
                child: MaterialButton(
                  onPressed: () async {
                    if(assertNoNullFields()) {
                      await AuthService().createUserWithEmailAndPassword(
                          email,
                          password,
                          firstName,
                          lastName,
                          deviceID,
                          address,
                          city,
                          state,
                          int.parse(zipCode),
                          phoneNumber,
                          int.parse(tankDepth),
                          selectedPhoneCarrier);
                      Navigator.pushNamed(context, '/home');
                      //TODO add push to home page and pull data from server to populate page.
                      }else{
                      print('missing fields');
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
