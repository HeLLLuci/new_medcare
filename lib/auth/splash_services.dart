import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_medcare/auth/login_page.dart';
import '../screens/admin/admin_screen.dart';
import '../screens/users/user_screen.dart';
import '../utils/toast_msg.dart';

class SplashServices {
  final auth = FirebaseAuth.instance;

  void isLogin(BuildContext context) async {
    final user = auth.currentUser;

    if (user != null) {

        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        if (data['role'] == 'Doctor') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const AdminScreen(),
              ));
        } else if (data['role'] == 'Patient') {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const UserScreen(),
              ));
        }else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => const LoginPage()));
        }
    } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  void logOut(BuildContext context) {
    auth.signOut().then((value) {
      Navigator.pushAndRemoveUntil(
          context, MaterialPageRoute(builder: (context) => const LoginPage()),(route) => false,);
    }).onError((error, stackTrace) {
      Utils().toastMsg("Something went wrong");
    });
  }
}
