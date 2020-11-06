import 'package:ez_salt/constants.dart';
import 'package:flutter/material.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About'),
        centerTitle: true,
      ),
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                'EZsalt',
                style: TextStyle(
                    fontFamily: 'EZSalt',
                    color: primaryThemeColor,
                    fontSize: 50,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.copyright_outlined,
                  color: Colors.black,
                ),
                Text(
                  '2020',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ],
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/licenses');
              },
              child: Text(
                'Licenses',
                style: TextStyle(
                    color: primaryThemeColor,
                    fontSize: 20,
                    decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
