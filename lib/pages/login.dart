import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ez_salt/components/custom_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('images/delivery.jpg'),
            ),
          ),
          child: Container(
            color: Colors.black54,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'EZSalt',
                  style: TextStyle(
                    fontFamily: 'EZSalt',
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Flexible(
                  child: SizedBox(
                    height: 30,
                  ),
                ),
                CustomTextField(
                  text: 'Username',
                  icon: Icon(Icons.person, color: Colors.white,),
                ),
                SizedBox(
                    height: 10
                ),
                CustomTextField(
                  text: 'Password',
                  icon: Icon(Icons.security, color: Colors.white,),
                ),
                Flexible(
                  child: SizedBox(
                    height: 40,
                  ),
                ),
                SizedBox(
                  width: 230,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ReusableOutlineButton(
                        size: 110,
                        label: Text('      Login', style: TextStyle(fontWeight: FontWeight.bold),),
                        icon: Icon(Icons.arrow_forward, size: 0,),
                        onPressed: (){
                          Navigator.pushNamed(context, '/home');
                        },
                      ),
                      ReusableOutlineButton(
                        size: 110,
                        label: Text('    Register', style: TextStyle(fontWeight: FontWeight.bold),),
                        icon: Icon(Icons.arrow_forward, size: 0,),
                        onPressed: (){
                          //Navigator.pushNamed(context, '/register');
                        },
                      ),
                    ],
                  ),
                ),
                ReusableOutlineButton(
                  size: 230,
                  icon: Icon(FontAwesomeIcons.google),
                  label: Text('   Continue with Google'),
                  onPressed: (){},
                ),
                ReusableOutlineButton(
                  size: 230,
                  icon: Icon(FontAwesomeIcons.facebook),
                  label: Text('   Continue with Facebook'),
                  onPressed: (){},
                ),
                ReusableOutlineButton(
                  size: 230,
                  icon: Icon(FontAwesomeIcons.apple),
                  label: Text('   Continue with Apple'),
                  onPressed: (){},
                ),
              ],
            ),
          ),
        ),
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


