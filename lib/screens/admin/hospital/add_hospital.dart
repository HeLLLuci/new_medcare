import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_medcare/widgets/data_input_card.dart';
import 'package:new_medcare/widgets/my_card_btn.dart';
import '../../../utils/decoration.dart';
import '../../../utils/toast_msg.dart';
import '../../../widgets/app_bar_back_btn.dart';

class AddHospital extends StatefulWidget {
  const AddHospital({Key? key}) : super(key: key);

  @override
  State<AddHospital> createState() => _AddHospitalState();
}

class _AddHospitalState extends State<AddHospital> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final hospitalNameController = TextEditingController();
  final doctorNameController = TextEditingController();
  final doctorSpecialityController = TextEditingController();
  final doctorDegreeController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final seatController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('hospital_names');


  void updateHospitalData() async {
    if (_formKey.currentState!.validate()
        && (hospitalNameController.text.isNotEmpty
            && RegExp(r'^[a-z A-Z0-9]+$').hasMatch(hospitalNameController.text))
        && (doctorNameController.text.isNotEmpty
            && RegExp(r'^[a-z A-Z0-9]+$').hasMatch(doctorNameController.text))
        && (doctorSpecialityController.text.isNotEmpty
            && RegExp(r'^[a-z A-Z0-9]+$').hasMatch(doctorSpecialityController.text))
        && (doctorDegreeController.text.isNotEmpty
            && RegExp(r'^[a-z A-Z0-9]+$').hasMatch(doctorDegreeController.text))
        && (addressController.text.isNotEmpty
            && RegExp(r'^[a-z A-Z0-9]+$').hasMatch(addressController.text))
        && (phoneController.text.isNotEmpty
            && RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(phoneController.text.trim()))
        && (seatController.text.isNotEmpty
            && RegExp(r'^[0-9]+$').hasMatch(seatController.text))
    ) {
      await firestore.doc(_auth.currentUser!.uid).set({
        'Hospital_name': hospitalNameController.text.toString(),
        'Dr_Name': doctorNameController.text.toString(),
        'Speciality': doctorSpecialityController.text.toString(),
        'Degree': doctorDegreeController.text.toString(),
        'Hospital_address': addressController.text.toString(),
        'Hospital_phone': phoneController.text.trim().toString(),
        'Available_seats': seatController.text.toString(),
        'Hospital_uid': FirebaseAuth.instance.currentUser!.uid,
      }).then((value) {
        Utils().toastMsg("Successful");
        hospitalNameController.clear();
        doctorNameController.clear();
        doctorSpecialityController.clear();
        doctorDegreeController.clear();
        addressController.clear();
        phoneController.clear();
        seatController.clear();
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
    doctorNameController.dispose();
    doctorSpecialityController.dispose();
    doctorDegreeController.dispose();
    addressController.dispose();
    phoneController.dispose();
    seatController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size  = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Patients",style: medCareTextStyle,),
        backgroundColor: allBgClr,
        centerTitle: true,
        leading: const AppBarBackBtn(),
        elevation: 0,
      ),
      backgroundColor: allBgClr,
      body:  Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height*0.05,),
              warningText,
              SizedBox(height: size.height*0.05,),
              Container(
                height: 500,
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
                        name: "Doctor Name:",
                        controller: doctorNameController,
                      ),
                      DataInputCard(
                        name: "Speciality:",
                        controller: doctorSpecialityController,
                      ),
                      DataInputCard(
                        name: "Degree:",
                        controller: doctorDegreeController,
                      ),
                      DataInputCard(
                        name: "Hospital Address:",
                        controller: addressController,
                      ),
                      DataInputCard(
                        name: "Phone Number:",
                        controller: phoneController,
                        hintText: "Enter 10 digit number",
                        keyBoardType: TextInputType.number,
                      ),
                      DataInputCard(
                        name: "Available Seats:",
                        controller: seatController,
                        keyBoardType: TextInputType.number,
                      ),
                      MyCardButton(
                        btnName: "Update",
                        shap: regularStyle,
                        press: () {
                          updateHospitalData();
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
