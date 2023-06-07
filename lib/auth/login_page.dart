import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_medcare/auth/signup_screen.dart';
import 'package:new_medcare/auth/splash_services.dart';
import '../utils/decoration.dart';
import '../utils/toast_msg.dart';
import '../widgets/button.dart';
import '../widgets/data_input_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLogin = false;
  bool obscure = false;
  final _auth = FirebaseAuth.instance;
  SplashServices splashServices = SplashServices();

  void loginWithRole() async {
    setState(() {
      isLogin = true;
    });
    try {
          await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
          checkLogin();
          Timer.periodic(const Duration(seconds: 10), (timer) {
            setState(() {
              isLogin = false;
            });
          });
    }catch(e){
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          Utils().toastMsg("User not found");
        } else if (e.code == 'wrong-password') {
          Utils().toastMsg("Incorrect password");
        }else if (e.code == 'invalid-email') {
          Utils().toastMsg("Please check your email");
        }
        else {
          Utils().toastMsg("Something went wrong");
        }
      }
      setState(() {
        isLogin = false;
      });
    }
  }

  void checkLogin(){
    splashServices.isLogin(context);
  }
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Stack(alignment: Alignment.bottomCenter, children: [
          Image.asset("assets/images/main_login.png"),
          Text("Login", style: medCareTextStyle),
        ]),
        const SizedBox(
          height: 20,
        ),
        Form(
            key: _formKey,
            child: Padding(
              padding: btnTextFieldPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DataInput(labelText: "Enter email", controller: emailController),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: "Enter password",
                      contentPadding: const EdgeInsets.all( 15),
                      labelStyle: const TextStyle(color: Colors.black),
                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          obscure = !obscure;
                        });
                      }, icon:
                      obscure
                          ? const Icon(Icons.visibility_off,color: Colors.black45)
                          : const Icon(Icons.visibility,color: Colors.black45,),
                      ),
                    ),
                    validator: (val){
                      if(val!.isEmpty){
                        return "Enter password";
                      }else{
                        return null;
                      }
                    },
                    obscureText: !obscure,
                    cursorHeight: 25,
                    cursorColor: blueBtnClr,
                  ),
                ],
              ),
            )),
        const SizedBox(
          height: 50,
        ),
        Padding(
          padding: btnTextFieldPadding,
          child: MyElevatedButton(
              btnName: !isLogin ? Text("Login",style: myElevatedButtonInnerTextStyle,) : const CircularProgressIndicator(color: Colors.white),
              press: () {
                if (_formKey.currentState!.validate()) {
                  loginWithRole();
                }
              }),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account ?"),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SignUpScreen()));
                },
                child: const Text("SignUp")),
          ],
        ),
      ]),
    );
  }
}