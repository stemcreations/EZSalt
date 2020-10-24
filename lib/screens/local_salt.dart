import 'package:flutter/material.dart';

class LocalSaltPage extends StatefulWidget {
  @override
  _LocalSaltPageState createState() => _LocalSaltPageState();
}

class _LocalSaltPageState extends State<LocalSaltPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        centerTitle: true,
        title: Text('EZSalt', style: TextStyle(fontFamily: 'EZSalt', fontWeight: FontWeight.w900),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello world'),
          ],
        ),
      ),
    );
  }
}
