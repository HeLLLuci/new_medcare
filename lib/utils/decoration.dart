import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color allBgClr = const Color(0xFFEEF2FF);
Color cardBgClr = Colors.white;
Color blueBtnClr = const Color.fromRGBO(69, 177, 255, 1);
Color dividerClr = const Color.fromRGBO(69, 177, 255, 1);
Color titleClr = const Color.fromRGBO(69, 177, 255, 1);
Color myElevatedButtonNameClr = Colors.white;
EdgeInsets btnTextFieldPadding = const EdgeInsets.symmetric(horizontal: 15);

TextStyle navBarTextStyle =  const TextStyle(fontSize: 11,fontWeight: FontWeight.w600);

TextStyle myElevatedButtonTextStyle = TextStyle(fontSize: 32, fontWeight: FontWeight.w400, color: myElevatedButtonNameClr);

TextStyle myElevatedButtonInnerTextStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: myElevatedButtonNameClr);

TextStyle cardNameTextStyle = TextStyle(fontSize: 22, fontWeight: FontWeight.w400, color: blueBtnClr);

TextStyle historyHospitalNameTextStyle = TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: blueBtnClr);

TextStyle cardInfoTextStyle = TextStyle(fontSize: 18, color: Colors.black.withOpacity(.7),fontWeight: FontWeight.w400);

TextStyle medCareTextStyle = GoogleFonts.pacifico(fontSize: 42, color: titleClr);

TextStyle noDataTextStyle = GoogleFonts.pacifico(fontSize: 32, color: titleClr);

TextStyle appBarTitleTextStyle = GoogleFonts.pacifico(fontSize: 32, color: titleClr);

const warningText = Text(
    "Note: This information will be visible to all users, do not submit wrong information.",
    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black54));

Decoration decoration = BoxDecoration(
  color: cardBgClr,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 1,
          offset: const Offset(0, 2), // changes position of shadow
        ),
  ],
);

MaterialStateProperty<OutlinedBorder?> regularStyle = MaterialStatePropertyAll(
    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)));

MaterialStateProperty<OutlinedBorder?> curveStyle =
    const MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
  bottomRight: Radius.circular(15),
  topLeft: Radius.circular(15),
)));
