import 'package:flutter/material.dart';
import '../utils/decoration.dart';

class MyCardButton extends StatelessWidget {
  final String btnName;
  final void Function()? press;
  final MaterialStateProperty<OutlinedBorder?>? shap;
  const MyCardButton({Key? key, required this.btnName, required this.press, this.shap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            backgroundColor:  MaterialStatePropertyAll(blueBtnClr),
            shape: shap,
        ),
        onPressed: press,
        child: Text(btnName,style: const TextStyle(fontSize: 18,color: Colors.white),)
    );
  }
}
