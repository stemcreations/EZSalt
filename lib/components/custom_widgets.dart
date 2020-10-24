import 'package:flutter/material.dart';
import 'package:ez_salt/constants.dart';
// =============== TEXT FIELDS BELOW =============== //

class CustomTextField extends StatelessWidget {
  CustomTextField({@required this.text, this.icon, this.keyboardType,
    this.obscureText = false, this.onChanged, this.maxLength, this.labelText,
    this.controller, this.initialValue, this.horizontalPadding = 35,
  });

  final double horizontalPadding;
  final String initialValue;
  final String text;
  final Icon icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function(String) onChanged;
  final int maxLength;
  final String labelText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 35, right: horizontalPadding, top: 5, bottom: 5),
      child: TextFormField(
        initialValue: initialValue,
        controller: controller,
        textInputAction: TextInputAction.next,
        maxLength: maxLength,
        onChanged: onChanged,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(
          color: borderAndTextColor
        ),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: labelText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: focusedBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderAndTextColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: borderAndTextColor),
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
  ReusableOutlineButton({this.icon, @required this.label, @required this.onPressed, @required this.size});
  final Icon icon;
  final Text label;
  final Function onPressed;
  final double size;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: size,
      child: MaterialButton(
        elevation: 4,
        color: Colors.grey.shade300,
        textColor: borderAndTextColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
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