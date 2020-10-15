import 'package:ez_salt/constants.dart';
import 'package:flutter/material.dart';
import 'package:wave_progress_widget/wave_progress_widget.dart';
import 'package:ez_salt/components/custom_widgets.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'dart:math' as math;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

//TODO choose between animated box and the circle graph

class _HomeState extends State<Home> {
  var progress = 75; //TODO create a function that pulls the salt tank level from the server and displays it in the app
  double monthlySubscriptionPrice = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        title: Text('EZSalt', style: TextStyle(fontFamily: 'EZSalt', fontWeight: FontWeight.w900),), //App Bar Text and Text style
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    //Sized box is to make it to where when screen size changes the box will change and keep the graph a circle
                    child: SizedBox(
                      width: 300,
                      height: 300,
                      child: CircularStepProgressIndicator(
                        startingAngle: math.pi * 5 / 4,
                        arcSize: math.pi * 3 / 2,
                        totalSteps: 100,
                        currentStep: progress,
                        stepSize: 25,
                        selectedColor: Colors.blue,
                        unselectedColor: Colors.grey[300],
                        padding: 0,
                        width: 300,
                        height: 300,
                        selectedStepSize: 25,
                        roundedCap: (_, __) => true,
                        child: Center(
                          child: Text(
                            '$progress%',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 50,
                              color: borderAndTextColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, bottom: 10),
              child: Divider(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '\$' + monthlySubscriptionPrice.toStringAsFixed(2),
                  style: TextStyle(
                    fontSize: 30,
                    color: borderAndTextColor,
                  ),
                ),
                Text(' Monthly', style: TextStyle(color: borderAndTextColor),)
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Slider(
                divisions: 18,
                max: 10,
                min: 1,
                value: monthlySubscriptionPrice,
                onChanged: (double value) {
                  setState(() {
                    monthlySubscriptionPrice = value;
                  });
                },
              ),
            ),
            // Text(
            //   '\$' + monthlySubscriptionPrice.toStringAsFixed(2) + ' Monthly',
            // ),
            FlatButton(
              onPressed: () {  },
              child: Text('Upgrade To Pro', style: TextStyle(color: borderAndTextColor),),
              color: Colors.grey.shade300,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ],
        ),
      ),
    );
  }
}
