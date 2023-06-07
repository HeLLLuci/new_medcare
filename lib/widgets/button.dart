import 'package:flutter/material.dart';
import 'package:new_medcare/utils/decoration.dart';


class MyElevatedButton extends StatelessWidget {
  final Widget btnName;
  void Function() press;
  MyElevatedButton({Key? key, required this.btnName,required this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 300,
      child: ElevatedButton(
          style: ButtonStyle(
              shape: regularStyle,
              backgroundColor: MaterialStatePropertyAll(blueBtnClr)
          ),
          onPressed: press,
          child: btnName
      ),
    );
  }
}
