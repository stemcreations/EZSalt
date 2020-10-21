import 'package:flutter/material.dart';
import 'package:ez_salt/constants.dart';
// =============== TEXT FIELDS BELOW =============== //

class CustomTextField extends StatelessWidget {
  CustomTextField({@required this.text, this.icon, this.keyboardType, this.obscureText = false, this.onChanged, this.maxLength, this.labelText});

  final String text;
  final Icon icon;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function(String) onChanged;
  final int maxLength;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 5),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (term){
          FocusScope.of(context).nextFocus();
        },
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
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: focusedBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: borderAndTextColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
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
      width: size,
      child: MaterialButton(
        elevation: 4,
        color: Colors.grey.shade300,
        textColor: borderAndTextColor,
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