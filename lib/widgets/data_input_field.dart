import 'package:flutter/material.dart';

import '../utils/decoration.dart';

class DataInput extends StatelessWidget {
  final String labelText;
  final String? hintText;
  final TextEditingController controller;
  const DataInput({Key? key,required this.labelText, required this.controller, this.hintText}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        labelText: labelText,
        hintText: hintText,
        contentPadding: const EdgeInsets.all(15),
        labelStyle: const TextStyle(color: Colors.black),
      ),
      validator: (val){
        if(val!.isEmpty){
          return labelText;
        }else{
          return null;
        }
      },
      cursorHeight: 25,
      cursorColor: blueBtnClr,
    );
  }
}