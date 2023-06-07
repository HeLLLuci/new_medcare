import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/decoration.dart';
import '../utils/toast_msg.dart';
import '../widgets/button.dart';
import '../widgets/data_input_field.dart';

class SignUpScreen extends StatefulWidget {
   const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   final emailController = TextEditingController();
   final passwordController = TextEditingController();
   final listItems = ['Patient','Doctor'];
   String defaultRole = 'Patient';
   bool isRegistering = false;
   bool obscure = false;

   Future<void> registerUser() async {
     if(_formKey.currentState!.validate()) {
       setState(() {
         isRegistering = true;
       });
       try{
         UserCredential userCredential =
             await FirebaseAuth.instance
             .createUserWithEmailAndPassword(
           email: emailController.text,
           password: passwordController.text,
         );
         User? user = userCredential.user;
         await FirebaseFirestore.instance
             .collection('users')
             .doc(user!.uid)
             .set({
           'email': emailController.text.toString(),
           'uid': user.uid.toString(),
           'role': defaultRole.toString(),
         });
         setState(() {
           isRegistering = false;
         });
         Utils().toastMsg("Registration successful");
         Timer.periodic(const Duration(seconds: 2), (timer) {
           Navigator.pop(context);
         });
       }catch(e){
         if (e is FirebaseAuthException) {
           if (e.code == 'user-not-found') {
             Utils().toastMsg("User not found");
           } else if (e.code == 'wrong-password') {
             Utils().toastMsg("Incorrect password");
           }else if (e.code == 'invalid-email') {
             Utils().toastMsg("Please check your email");
           } else if (e.code == 'email-already-in-use') {
             Utils().toastMsg("User already exists, try with another email");
           }else if (e.code == 'weak-password') {
             Utils().toastMsg("Please enter more than 6 character password");
           }
           else {
             Utils().toastMsg(e.toString());
           }
         }
         setState(() {
           isRegistering = false;
         });
       }
     }}

   @override
   void dispose() {
     super.dispose();
     emailController.dispose();
     passwordController.dispose();
   }

   DropdownMenuItem<String> buildItem(String item) => DropdownMenuItem(
     value: item,
       child: Text(item,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w400,color: Colors.blueGrey),)
   );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Stack(alignment: Alignment.bottomCenter, children: [
          Image.asset("assets/images/admin.png"),
          Text("Register", style: medCareTextStyle),
        ]),
        const SizedBox(
          height: 30,
        ),
        Form(
            key: _formKey,
            child: Padding(
              padding: btnTextFieldPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DataInput( labelText: "Enter email address", controller: emailController,),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      labelText: "Enter password",
                      hintText: "Enter more than 6 character password",
                      hintStyle: const TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.w400),
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
                  const SizedBox(height: 15,),
                  DropdownButton(
                    value: defaultRole,
                    items: listItems.map(buildItem).toList(),
                    onChanged: (value) => setState(() {
                      defaultRole = value!;
                    }),
                  ),
                ],
              ),
            )),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: btnTextFieldPadding,
          child: MyElevatedButton(
              btnName: !isRegistering ? Text("Register",style: myElevatedButtonInnerTextStyle,) : const CircularProgressIndicator(color: Colors.white),
              press: () {
                if (_formKey.currentState!.validate()) {
                  registerUser();
                }
              }),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account ?"),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Login")),
          ],
        ),
      ]),
    );
  }
}