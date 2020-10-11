import 'package:flutter/material.dart';

// =============== TEXT FIELDS BELOW =============== //

class CustomTextField extends StatelessWidget {
  CustomTextField({@required this.text, @required this.icon});

  final String text;
  final Icon icon;
  final Color borderAndTextColor = Colors.indigo;
  final Color focusedBorderColor = Colors.indigoAccent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: TextField(
        style: TextStyle(
          color: borderAndTextColor
        ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: focusedBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: borderAndTextColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: borderAndTextColor)
          ),
          hintText: text,
          hintStyle: TextStyle(
            color: borderAndTextColor,
          ),
          prefixIcon: icon,
        ),
      ),
    );
  }
}

// ============= BUTTONS BELOW =============== //

class ReusableOutlineButton extends StatelessWidget {
  ReusableOutlineButton({this.icon, this.label,@required this.onPressed,@required this.size});
  final Icon icon;
  final Text label;
  final Function onPressed;
  final double size;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: FlatButton(
        //borderSide: BorderSide(color: Colors.white),
        color: Colors.grey.withAlpha(125),
        textColor: Colors.indigo,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        //icon: icon,
        //label: label,
        child: Row(
          children: [
            icon,
            label,
          ],
        ),
        onPressed: onPressed,
      ),
    );
  }
}