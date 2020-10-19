import 'package:ez_salt/components/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:ez_salt/constants.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
              Text(
                'EZSalt',
                style: TextStyle(
                  fontFamily: 'EZSalt',
                  color: borderAndTextColor,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              CustomTextField(text: 'Email Address',), //email / username
              CustomTextField(text: 'Password', obscureText: true,), //password
              CustomTextField(text: 'Confirm Password', obscureText: true,), //re-enter password
              CustomTextField(text: 'Tank Depth', keyboardType: TextInputType.number,),
              CustomTextField(text: 'Device ID',),//tank depth
              MaterialButton(
                onPressed: () {  },
                child: Text('Submit', style: TextStyle(color: borderAndTextColor),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.grey.shade300,
                elevation: 3,
              ), //Submit button
            ],
          ),
        ),
      ),
    );
  }
}
