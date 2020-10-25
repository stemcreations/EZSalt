import 'package:ez_salt/constants.dart';
import 'package:ez_salt/networking/authentication.dart';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'dart:math' as math;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tankLevel = 1;
  double monthlySubscriptionPrice = 3;

  //This function pulls the current tank level readings from firebase and refreshes the state
  void getTankLevel() async {
    var doubleTankLevel = await AuthService().getTankLevel();
    if(doubleTankLevel.runtimeType == double){
      String stringTankLevel = doubleTankLevel.toString();
      tankLevel = double.parse(stringTankLevel).floor().toInt();
    }else {
      tankLevel = doubleTankLevel;
    }
    if(tankLevel <= 0){
      tankLevel = 1;
    }
    setState(() {
    });
  }

  @override
  void dispose() {
    AuthService().signOutGoogle();
    super.dispose();
  }

  @override
  void initState() {
    getTankLevel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/profile');
              },
                child: Icon(Icons.settings)
          ),
            ),
        ],
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
                        currentStep: tankLevel,
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
                            '$tankLevel%',
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
              child: Container(child: Divider(thickness: 2,)),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   crossAxisAlignment: CrossAxisAlignment.baseline,
            //   textBaseline: TextBaseline.alphabetic,
            //   children: [
            //     Text(
            //       '\$' + monthlySubscriptionPrice.toStringAsFixed(2),
            //       style: TextStyle(
            //         fontSize: 30,
            //         color: borderAndTextColor,
            //       ),
            //     ),
            //     Text(' Monthly', style: TextStyle(color: borderAndTextColor),)
            //   ],
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 50),
            //   child: Slider(
            //     divisions: 18,
            //     max: 10,
            //     min: 1,
            //     value: monthlySubscriptionPrice,
            //     onChanged: (double value) {
            //       setState(() {
            //         monthlySubscriptionPrice = value;
            //       });
            //     },
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: MaterialButton(
                elevation: 3,
                height: 40,
                onPressed: () {  },
                child: Text('Schedule Delivery', style: TextStyle(color: borderAndTextColor),),
                color: Colors.grey.shade300,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
