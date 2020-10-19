import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ez_salt/components/custom_widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ez_salt/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

//TODO Need firebase authentication integration for login/register/forgot password/facebook and google

class _LoginPageState extends State<LoginPage> {
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
              CustomTextField(
                onChanged: (text){
                  setState(() {
                    email = text.trim();
                  });
                },
                text: 'Username',
                icon: Icon(Icons.person, color: borderAndTextColor,),
              ),
              CustomTextField(
                onChanged: (text){
                  setState(() {
                    password = text.trim();
                  });
                },
                obscureText: true,
                text: 'Password',
                icon: Icon(Icons.security, color: borderAndTextColor,),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: MaterialButton(
                      onPressed: () {  },  //TODO need to add function to forgot password
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(color: borderAndTextColor),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 230,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableOutlineButton(
                      size: 110,
                      label: Text('      Login', style: TextStyle(fontWeight: FontWeight.bold),),
                      icon: Icon(Icons.arrow_forward, size: 0, ),
                      onPressed: () async {
                        await AuthService().signInWithEmailAndPassword(email, password);
                        var depth = await AuthService().getTankLevel();
                        print(depth);
                        Map data = await AuthService().getProfile();
                        print(data);
                        Navigator.pushNamed(context, '/home');
                      },
                    ),
                    ReusableOutlineButton(
                      size: 110,
                      label: Text('    Register', style: TextStyle(fontWeight: FontWeight.bold),),
                      icon: Icon(Icons.arrow_forward, size: 0,),
                      onPressed: (){
                        Navigator.pushNamed(context, '/register');
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      child: Divider(
                        indent: 70,
                        endIndent: 5,
                        thickness: 2,
                        color: borderAndTextColor,
                      ),
                    ),
                  ),
                  Text(
                    'OR',
                    style: TextStyle(color: borderAndTextColor),
                  ),
                  Expanded(
                    child: Container(
                      child: Divider(
                        indent: 5,
                        endIndent: 70,
                        thickness: 2,
                        color: borderAndTextColor,
                      ),
                    ),
                  ),
                ],
              ),
              ReusableOutlineButton(
                size: 230,
                icon: Icon(FontAwesomeIcons.google),
                label: Text('   Continue with Google'),
                onPressed: (){},
              ),
              //TODO add facebook login integration with firebase and facebook to allow signin with Facebook
              // Padding(
              //   padding: const EdgeInsets.only(bottom: 3),
              //   child: ReusableOutlineButton(
              //     size: 230,
              //     icon: Icon(FontAwesomeIcons.facebook),
              //     label: Text('   Continue with Facebook'),
              //     onPressed: (){},
              //   ),
              // ),
            ],
          ),
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


