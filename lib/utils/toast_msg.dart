import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../auth/splash_services.dart';

class Utils {

  SplashServices splashServices = SplashServices();

  void toastMsg(String errorMsg){
    Fluttertoast.showToast(
        msg: errorMsg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.greenAccent.shade200,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  void dialog(BuildContext context){
    showDialog(context: context, builder: (context) {
      return AlertDialog(
        scrollable: true,
        backgroundColor: Colors.blue.shade50,
        title: const Text("Exit"),
        alignment: Alignment.center,
        actions: [
          TextButton(onPressed: (){
            splashServices.logOut(context);
          }, child: const Text("Yes",style: TextStyle(fontSize: 18,color: Colors.blueGrey),)),
          TextButton(onPressed: (){
            Navigator.pop(context);
          }, child: const Text("No",style: TextStyle(fontSize: 18,color: Colors.blueGrey),)),
        ],
      );
    },);
  }

 }