import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../utils/decoration.dart';
import '../../../utils/toast_msg.dart';
import '../../../widgets/app_bar_back_btn.dart';
import '../../../widgets/data_input_card.dart';
import '../../../widgets/my_card_btn.dart';

class UpdateAmbulanceScreen extends StatefulWidget {
  const UpdateAmbulanceScreen({Key? key}) : super(key: key);

  @override
  State<UpdateAmbulanceScreen> createState() => _UpdateAmbulanceScreenState();
}

class _UpdateAmbulanceScreenState extends State<UpdateAmbulanceScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final hospitalNameController = TextEditingController();
  final driverNameController = TextEditingController();
  final phoneController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('Ambulance');

  void updateAmbulanceData() async {
    if(_formKey.currentState!.validate()
        && (hospitalNameController.text.isNotEmpty
            && RegExp(r'^[a-z A-Z0-9]+$').hasMatch(hospitalNameController.text))
        && (driverNameController.text.isNotEmpty
            && RegExp(r'^[a-z A-Z]+$').hasMatch(driverNameController.text))
        && (phoneController.text.isNotEmpty
            && RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(phoneController.text.trim()))
    )  {
      await firestore.doc(_auth.currentUser!.uid).set({
        'HospitalName': hospitalNameController.text.toString(),
        'DriverName': driverNameController.text.toString(),
        'DriverPhoneNo': phoneController.text.trim().toString(),
      }).then((value) {
        Utils().toastMsg("Successful");
        setState(() {
          hospitalNameController.clear();
          driverNameController.clear();
          phoneController.clear();
        });
      }).onError((error, stackTrace) {
        Utils().toastMsg("Something went wrong");
      });
    }else{
      Utils().toastMsg("Please enter all details");
    }
  }
  @override
  void dispose() {
    super.dispose();
    hospitalNameController.dispose();
    driverNameController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
        title: Text("Patients",style: medCareTextStyle,),
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
            SizedBox(height: size.height*0.1,),
            warningText,
            SizedBox(height: size.height*0.1,),
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
                      name: "Hospital Name:",
                      controller: hospitalNameController,
                    ),
                    DataInputCard(
                      name: "Driver Name:",
                      controller: driverNameController,
                    ),
                    DataInputCard(
                      name: "Driver Phone No:",
                      hintText: "Enter 10 digit number",
                      controller: phoneController,
                      keyBoardType: TextInputType.number,
                    ),
                    MyCardButton(
                      btnName: "Update",
                      shap: regularStyle,
                      press: () {
                        updateAmbulanceData();
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: size.height*0.05,),
          ],
        ),
      ),
      ),
    );
  }
}
