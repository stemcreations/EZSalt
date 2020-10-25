import 'package:ez_salt/components/custom_widgets.dart';
import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ez_salt/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _isAsyncCall = false;
  String selectedPhoneCarrier;
  String firstName;
  String lastName;
  String email;
  String password;
  String confirmedPassword;
  String phoneNumber;
  bool passwordsMatch;
  IconData icon;
  Color iconColor;
  final formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showSnackBar(String message){
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message),));
  }

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
        && email != null && passwordsMatch != false && phoneNumber != null
    ){
      return true;
    }else {
      return false;
    }
  }

  void checkPasswordMatch(){
    if(password == confirmedPassword){
      setState(() {
        icon = Icons.check;
        iconColor = Colors.green;
        passwordsMatch = true;
      });
    }else{
      setState(() {
        icon = Icons.clear;
        iconColor = Colors.red;
        passwordsMatch = false;
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
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Center(
        child: ModalProgressHUD(
          inAsyncCall: _isAsyncCall,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
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
                  CustomTextField(text: 'Email Address', onChanged: (text) => email = text.trim(), keyboardType: TextInputType.emailAddress,), //email / username
                  CustomTextField(text: 'Password', obscureText: true, onChanged: (text) => password = text.trim(), icon: Icon(icon, color: iconColor,),), //password
                  CustomTextField(text: 'Confirm Password', obscureText: true, onChanged: (text){
                    confirmedPassword = text;
                    checkPasswordMatch();
                    },
                    icon: Icon(icon, color: iconColor,),
                  ), //re-enter password
                  Padding(
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
                          items: dropDownBuilder(),
                          onChanged: (value) {
                            setState(() {
                              selectedPhoneCarrier = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ), // Dropdown menu for phone providers.
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 20),
                    child: MaterialButton(
                      onPressed: () async {
                        if(assertNoNullFields()) {
                          setState(() {
                            _isAsyncCall = true;
                          });
                          await AuthService().createUserWithEmailAndPassword(
                              email,
                              password,
                              firstName,
                              lastName,
                              phoneNumber,
                              selectedPhoneCarrier);
                          formKey.currentState.reset();
                          setState(() {
                            _isAsyncCall = false;
                          });
                          Navigator.pushNamed(context, '/deviceSetup');
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
        ),
      ),
    );
  }
}
