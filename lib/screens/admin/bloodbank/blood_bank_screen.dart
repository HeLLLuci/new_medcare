import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../utils/decoration.dart';
import '../../../utils/toast_msg.dart';
import '../../../widgets/app_bar_back_btn.dart';
import '../../../widgets/data_input_card.dart';
import '../../../widgets/my_card_btn.dart';

class UpdateBloodBankScreen extends StatefulWidget {
  const UpdateBloodBankScreen({Key? key}) : super(key: key);
  @override
  State<UpdateBloodBankScreen> createState() => _UpdateBloodBankScreenState();
}

class _UpdateBloodBankScreenState extends State<UpdateBloodBankScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final bbNameController = TextEditingController();
  final bbAddController = TextEditingController();
  final bbPhoneController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('Blood_Bank');

  void updateBloodBankData() async {
    if (_formKey.currentState!.validate() &&
        (bbNameController.text.isNotEmpty &&
            RegExp(r'^[a-z A-Z0-9]+$').hasMatch(bbNameController.text)) &&
        (bbAddController.text.isNotEmpty &&
            RegExp(r'^[a-z A-Z0-9]+$').hasMatch(bbAddController.text)) &&
        (bbPhoneController.text.isNotEmpty &&
            RegExp(r'^(?:[+0]9)?[0-9]{10}$')
                .hasMatch(bbPhoneController.text.trim()))) {
      await firestore.doc(_auth.currentUser!.uid).set({
        'BloodBankName': bbNameController.text.toString(),
        'BloodBankUid': FirebaseAuth.instance.currentUser!.uid,
        'BloodBankAddress': bbAddController.text.toString(),
        'BloodBankPhone': bbPhoneController.text.trim().toString(),
      }).then((value) {
        Utils().toastMsg("Successful");
        bbNameController.clear();
        bbAddController.clear();
        bbPhoneController.clear();
      }).onError((error, stackTrace) {
        Utils().toastMsg("Something went wrong");
      });
    } else {
      Utils().toastMsg("Please enter all details");
    }
  }

  @override
  void dispose() {
    super.dispose();
    bbNameController.dispose();
    bbAddController.dispose();
    bbPhoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Patients",
          style: medCareTextStyle,
        ),
        backgroundColor: allBgClr,
        centerTitle: true,
        leading: const AppBarBackBtn(),
        elevation: 0,
      ),
      backgroundColor: allBgClr,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              warningText,
              SizedBox(
                height: size.height * 0.1,
              ),
              Container(
                height: 250,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: decoration,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DataInputCard(
                        name: "Blood Bank Name:",
                        controller: bbNameController,
                      ),
                      DataInputCard(
                        name: "Address:",
                        controller: bbAddController,
                      ),
                      DataInputCard(
                        name: "Phone Number:",
                        controller: bbPhoneController,
                        hintText: "Enter 10 digit number",
                        keyBoardType: TextInputType.number,
                      ),
                      MyCardButton(
                        btnName: "Update",
                        shap: regularStyle,
                        press: () {
                          updateBloodBankData();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
