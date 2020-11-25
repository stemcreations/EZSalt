import 'package:flutter/material.dart';

class CommonFunctions {
  double getTopNotchSize(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  int doubleToInt(double newDouble) {
    return newDouble.floor().toInt();
  }

  int stringToInt(String string) {
    return double.parse(string).floor().toInt();
  }

  void showCustomSnackBar(BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey, String content) {
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              content,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
      elevation: 1000,
      backgroundColor: Colors.transparent,
      behavior: SnackBarBehavior.floating,
      //backgroundColor: Colors.transparent,
    ));
  }
}
