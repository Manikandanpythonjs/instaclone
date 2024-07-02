import 'package:flutter/material.dart';

class FollowBTN extends StatelessWidget {
  final Function()? function;
  final Color backgroundcolor;
  final Color borderColor;
  final String text;
  final Color textColor;

  const FollowBTN(
      {Key? key,
      this.function,
      required this.backgroundcolor,
      required this.borderColor,
      required this.text,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: TextButton(
        onPressed: function,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundcolor,
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 2,
          // height: MediaQuery.of(context).size.height / 30,

          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ),
        ),

      ),
    );
  }
}
