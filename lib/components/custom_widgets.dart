import 'package:flutter/material.dart';
import 'package:ez_salt/constants.dart';
// =============== TEXT FIELDS BELOW =============== //

class CustomTextField extends StatelessWidget {
  CustomTextField({@required this.text, this.icon, this.keyboardType,
    this.obscureText = false, @required this.onChanged, this.maxLength, this.labelText,
    this.controller, this.initialValue, this.horizontalPadding = 35, this.autoFocus = false,
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
  final bool autoFocus;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 35, right: horizontalPadding, top: 5, bottom: 5),
      child: TextFormField(
        autofocus: autoFocus,
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
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.4),
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: MaterialButton(
          //elevation: 4,
          color: Colors.grey.shade200,
          textColor: borderAndTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Row(
            children: [
              icon,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    label,
                  ],
                ),
              ),
            ],
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}

// ============= CUSTOM CARD VIEWS ==============//

class TwoLineCustomCard extends StatelessWidget {
  TwoLineCustomCard({this.firstLine, this.secondLine, this.icon, this.enterEditMode, this.onTap});

  final String firstLine;
  final String secondLine;
  final IconData icon;
  final bool enterEditMode;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Card(child: Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 35, bottom: 35, right: 10),
                child: Icon(icon, color: Colors.grey.shade600,),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 40,
                        child: VerticalDivider(color: Colors.black, thickness: .6,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(firstLine, style: TextStyle(color: Colors.grey.shade600, fontSize: 16),),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 40,
                        child: VerticalDivider(color: Colors.black, thickness: .6,),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(secondLine, style: TextStyle(color: Colors.grey.shade600, fontSize: 16),),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Visibility(
            child: GestureDetector(
              onTap: onTap,
              child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Icon(Icons.edit, color: Colors.grey.shade600,),
            ),),
            visible: enterEditMode,
          ),
        ],
      ),
    ],
    ),
    );
  }
}

class CustomProfileCard extends StatelessWidget {
  CustomProfileCard({@required this.cardData, this.icon, this.enterEditMode, this.onTap});

  final String cardData;
  final Icon icon;
  final bool enterEditMode;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 20, right: 10),
                    child: icon,
                  ),
                  Container(
                    height: 50,
                    child: VerticalDivider(color: Colors.black, thickness: .6,),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(cardData, style: TextStyle(color: Colors.grey.shade600, fontSize: 16),),
                  ),
                ],
              ),

            ],
          ),
          Visibility(
            child: GestureDetector(
              onTap: onTap,
              child: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Icon(Icons.edit, color: Colors.grey.shade600,),
            ),),
            visible: enterEditMode,
          ),
        ],
      ),
    );
  }
}

