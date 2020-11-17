import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:ez_salt/constants.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// =============== TEXT FIELDS BELOW =============== //

class CustomTextField extends StatelessWidget {
  CustomTextField({
    @required this.text,
    this.icon,
    this.keyboardType,
    this.obscureText = false,
    @required this.onChanged,
    this.maxLength,
    this.labelText,
    this.controller,
    this.initialValue,
    this.horizontalPadding = 35,
    this.autoFocus = false,
    this.textCapitalization = TextCapitalization.words,
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
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 35, right: horizontalPadding, top: 5, bottom: 5),
      child: TextFormField(
        textCapitalization: textCapitalization,
        autofocus: autoFocus,
        initialValue: initialValue,
        controller: controller,
        textInputAction: TextInputAction.next,
        maxLength: maxLength,
        onChanged: onChanged,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: primaryThemeColor),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: primaryThemeColor),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: focusedBorderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryThemeColor),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: primaryThemeColor),
          ),
          hintText: text,
          hintStyle: TextStyle(
            color: primaryThemeColor,
          ),
          prefixIcon: icon,
        ),
      ),
    );
  }
}

// ============= BUTTONS BELOW =============== //

class ReusableOutlineButton extends StatelessWidget {
  ReusableOutlineButton(
      {@required this.icon,
      @required this.label,
      @required this.onPressed,
      @required this.size});
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
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.4),
              blurRadius: 3,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: MaterialButton(
          //elevation: 4,
          color: Colors.grey.shade200,
          textColor: primaryThemeColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
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
  TwoLineCustomCard(
      {this.firstLine,
      this.secondLine,
      this.icon,
      this.enterEditMode,
      this.onTap});

  final String firstLine;
  final String secondLine;
  final IconData icon;
  final bool enterEditMode;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 35, bottom: 35, right: 10),
                    child: Icon(
                      icon,
                      color: primaryThemeColor,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 40,
                            child: VerticalDivider(
                              color: Colors.black,
                              thickness: .6,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: SizedBox(
                                height: 20,
                                width: MediaQuery.of(context).size.width / 1.6,
                                child: AutoSizeText(
                                  firstLine,
                                  style: TextStyle(
                                      color: primaryThemeColor, fontSize: 16),
                                  minFontSize: 10,
                                )),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            height: 40,
                            child: VerticalDivider(
                              color: Colors.black,
                              thickness: .6,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: SizedBox(
                              height: 20,
                              width: MediaQuery.of(context).size.width / 1.6,
                              child: AutoSizeText(
                                secondLine,
                                style: TextStyle(
                                    color: primaryThemeColor, fontSize: 16),
                                minFontSize: 10,
                              ),
                            ),
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
                    padding: const EdgeInsets.only(right: 15.0, left: 5),
                    child: Icon(
                      Icons.edit,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
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
  CustomProfileCard(
      {@required this.cardData, this.icon, this.enterEditMode, this.onTap});

  final String cardData;
  final IconData icon;
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
                    padding: const EdgeInsets.only(
                        left: 20.0, top: 20, bottom: 20, right: 10),
                    child: Icon(
                      icon,
                      color: primaryThemeColor,
                    ),
                  ),
                  Container(
                    height: 50,
                    child: VerticalDivider(
                      color: Colors.black,
                      thickness: .6,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: SizedBox(
                      height: 20,
                      width: MediaQuery.of(context).size.width / 1.6,
                      child: AutoSizeText(
                        cardData,
                        style:
                            TextStyle(color: primaryThemeColor, fontSize: 16),
                      ),
                    ),
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
                child: Icon(
                  Icons.edit,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            visible: enterEditMode,
          ),
        ],
      ),
    );
  }
}

// ================== CUSTOM BOTTOM SHEETS =========//

class CustomBottomSheet extends StatelessWidget {
  CustomBottomSheet(
      {@required this.context,
      @required this.label,
      @required this.inputType,
      @required this.hintText,
      @required this.onPressed,
      @required this.onChanged,
      @required this.onCancelPressed});
  final String label;
  final BuildContext context;
  final TextInputType inputType;
  final String hintText;
  final Function onPressed;
  final Function onChanged;
  final Function onCancelPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: primaryThemeColor,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CustomTextField(
                keyboardType: inputType,
                text: hintText,
                onChanged: onChanged,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusableOutlineButton(
                    icon: Icon(
                      Icons.add,
                      size: 0,
                    ),
                    label: Text('Cancel'),
                    onPressed: onCancelPressed,
                    size: 100),
                SizedBox(
                  width: 20,
                ),
                ReusableOutlineButton(
                    icon: Icon(
                      Icons.add,
                      size: 0,
                    ),
                    label: Text('Submit'),
                    onPressed: onPressed,
                    size: 100),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomPhoneBottomSheet extends StatelessWidget {
  CustomPhoneBottomSheet(
      {@required this.context,
      @required this.label,
      @required this.inputType,
      @required this.hintText,
      @required this.onPressed,
      @required this.onChanged,
      @required this.onCancelPressed,
      @required this.picker});
  final String label;
  final BuildContext context;
  final TextInputType inputType;
  final String hintText;
  final Function onPressed;
  final Function onChanged;
  final Function onCancelPressed;
  final Widget picker;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Platform.isAndroid ? 290 : 350,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: primaryThemeColor,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                height: Platform.isIOS ? 150 : null,
                alignment: Alignment.center,
                child: picker,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: CustomTextField(
                keyboardType: inputType,
                text: hintText,
                onChanged: onChanged,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusableOutlineButton(
                    icon: Icon(
                      Icons.add,
                      size: 0,
                    ),
                    label: Text('Cancel'),
                    onPressed: onCancelPressed,
                    size: 100),
                SizedBox(
                  width: 20,
                ),
                ReusableOutlineButton(
                    icon: Icon(
                      Icons.add,
                      size: 0,
                    ),
                    label: Text('Submit'),
                    onPressed: onPressed,
                    size: 100),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CustomBottomSheetWithCamera extends StatelessWidget {
  CustomBottomSheetWithCamera(
      {@required this.context,
      @required this.label,
      @required this.inputType,
      @required this.hintText,
      @required this.onPressed,
      @required this.onChanged,
      @required this.onCancelPressed,
      @required this.onTap,
      this.controller});
  final String label;
  final BuildContext context;
  final TextInputType inputType;
  final String hintText;
  final Function onPressed;
  final Function onChanged;
  final Function onCancelPressed;
  final Function onTap;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: primaryThemeColor,
                fontSize: 16,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: controller,
                      keyboardType: inputType,
                      text: hintText,
                      onChanged: onChanged,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15, right: 15),
                    child: BarcodeScanIcon(onTap: onTap),
                  )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusableOutlineButton(
                    icon: Icon(
                      Icons.add,
                      size: 0,
                    ),
                    label: Text('Cancel'),
                    onPressed: onCancelPressed,
                    size: 100),
                SizedBox(
                  width: 20,
                ),
                ReusableOutlineButton(
                    icon: Icon(
                      Icons.add,
                      size: 0,
                    ),
                    label: Text('Submit'),
                    onPressed: onPressed,
                    size: 100),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class BarcodeScanIcon extends StatelessWidget {
  BarcodeScanIcon({
    @required this.onTap,
  });
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 17, right: 35),
          child: Row(
            children: [
              Text(
                '[',
                style: TextStyle(color: primaryThemeColor, fontSize: 40),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: FaIcon(
                  FontAwesomeIcons.barcode,
                  color: primaryThemeColor,
                  size: 35,
                ),
              ),
              Text(
                ']',
                style: TextStyle(color: primaryThemeColor, fontSize: 40),
              ),
            ],
          ),
        ),
        onTap: onTap);
  }
}
