import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

void nextScreen(context, page) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenNamed(context, page) {
  Navigator.pushNamed(context, page);
}

void nextScreenReplace(context, page) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => page));
}

void nextScreenCloseOthers(context, page) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => page), (route) => false);
}

void nextScreenModalBottom(BuildContext context, Widget page) {
  showMaterialModalBottomSheet(
    expand: false,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => page,
  );
}

void nextScreenModalBottomDisableDrag(BuildContext context, Widget page) {
  showMaterialModalBottomSheet(
    expand: false,
    enableDrag: false,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => page,
  );
}

void nextScreenModalDialog(BuildContext context, Widget page) {
  showDialog(
    context: context,
    builder: (context) => page,
  );
}
