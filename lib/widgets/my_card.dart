import 'package:flutter/material.dart';

import '../utils/decoration.dart';

class MyCard extends StatelessWidget {
  final Widget child;
  const MyCard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 2,
      surfaceTintColor: cardBgClr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: child,
      ),
    );
  }
}
