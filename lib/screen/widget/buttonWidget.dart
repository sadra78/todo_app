import 'package:flutter/material.dart';
import 'package:todo_app/constants.dart';

class ButtonWidget extends StatelessWidget {
  final String? title;
  final bool? hasBorder;

  ButtonWidget({this.title, this.hasBorder});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
          color: hasBorder! ? whiteColor : mediumBlue,
          borderRadius: BorderRadius.circular(10),
          border: hasBorder!
              ? Border.all(color: mediumBlue)
              : Border.fromBorderSide(BorderSide.none)),
      child: Container(
        alignment: Alignment.center,
        child: Text(
          title!,
          style: TextStyle(color: hasBorder! ? mediumBlue : whiteColor),
        ),
      ),
    );
  }
}
