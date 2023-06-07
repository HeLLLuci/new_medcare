import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_medcare/utils/toast_msg.dart';

class LogOutBtn extends StatelessWidget {
  const LogOutBtn({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: (){
      Utils().dialog(context);
    }, icon: const Icon(MdiIcons.logout,color: Colors.blueGrey,));
  }
}
