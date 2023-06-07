import 'package:flutter/material.dart';

class AppBarBackBtn extends StatelessWidget {
  const AppBarBackBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  IconButton(onPressed: (){
      Navigator.pop(context);
    }, icon: const Icon(Icons.arrow_back,color: Colors.blueGrey,size: 30,));
  }
}
