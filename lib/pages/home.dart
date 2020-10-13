import 'package:flutter/material.dart';
import 'package:wave_progress_widget/wave_progress_widget.dart';
import 'package:ez_salt/components/custom_widgets.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

//TODO choose between animated box and the circle graph

class _HomeState extends State<Home> {
  var progress = 75; //TODO create a function that pulls the salt tank level from the server and displays it in the app

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        title: Text('EZSalt', style: TextStyle(fontFamily: 'EZSalt', fontWeight: FontWeight.w900),), //App Bar Text and Text style
      ),
      body: Padding(
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
                  totalSteps: 100,
                  currentStep: progress,
                  stepSize: 10,
                  selectedColor: Colors.indigoAccent,
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
                        color: Colors.indigo
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
