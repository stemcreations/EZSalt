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
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(text: 'Username / Email',), //email / username
              CustomTextField(text: 'Password',), //password
              CustomTextField(text: 'Re-Enter Password',), //re-enter password
              CustomTextField(text: 'Tank Depth', keyboardType: TextInputType.number,),
              CustomTextField(text: 'Device ID',),//tank depth
              FlatButton(
                onPressed: () {  },
                child: Text('Submit', style: TextStyle(color: borderAndTextColor),),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Colors.grey.shade300,
              ), //Submit button
            ],
          ),
        ),
      ),
    );
  }
}
