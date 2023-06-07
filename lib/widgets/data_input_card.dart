import 'package:flutter/material.dart';
import 'package:new_medcare/utils/decoration.dart';

class DataInputCard extends StatelessWidget {
  final String name;
  final String? hintText;
  final TextInputType? keyBoardType;
  final TextEditingController controller;
  const DataInputCard({Key? key, required this.name, required this.controller, this.keyBoardType, this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 4,child: Text(name,style: const TextStyle(fontSize: 18,color: Color(0xFF474E68)),)),
        Expanded(
          flex: 5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: allBgClr,
              ),
              child: TextFormField(
                controller: controller,
                keyboardType: keyBoardType,
                cursorColor: blueBtnClr,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          color: Colors.grey
                      )
                  ),
                  focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(
                          color: Colors.grey
                      )
                  ),
                  contentPadding: const EdgeInsets.only(left: 10),
                  hintText: hintText,
                  hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.w400)
                ),
              ),
            )
        )
      ],
    );
  }
}
