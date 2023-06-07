import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_medcare/widgets/app_bar_back_btn.dart';
import '../../../utils/decoration.dart';
import '../../../utils/toast_msg.dart';
import '../../../widgets/data_input_card.dart';
import '../../../widgets/my_card.dart';
import '../../../widgets/my_card_btn.dart';

class SeatBookingScreen extends StatefulWidget {
  final String hospitalUid;
  final String hospitalName;
  final String drName;
  final String speciality;
  final String degree;

  const SeatBookingScreen(
      {Key? key,
      required this.hospitalUid,
      required this.hospitalName,
      required this.drName,
      required this.speciality,
      required this.degree})
      : super(key: key);

  @override
  State<SeatBookingScreen> createState() => _SeatBookingScreenState();
}

class _SeatBookingScreenState extends State<SeatBookingScreen> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final patientNameController = TextEditingController();
  final patientAddressController = TextEditingController();
  final patientAgeController = TextEditingController();
  final patientPhoneController = TextEditingController();
  DateTime now = DateTime.now();

  void bookHospitalBed() async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    if (_formKey.currentState!.validate() &&
        (patientNameController.text.isNotEmpty &&
            RegExp(r'^[a-z A-Z]+$').hasMatch(patientNameController.text)) &&
        (patientAddressController.text.isNotEmpty &&
            RegExp(r'^[a-z A-Z0-9]+$')
                .hasMatch(patientAddressController.text)) &&
        (patientPhoneController.text.isNotEmpty &&
            RegExp(r'^(?:[+0]9)?[0-9]{10}$')
                .hasMatch(patientPhoneController.text.trim())) &&
        (patientAgeController.text.isNotEmpty &&
            RegExp(r'^[0-9]+$').hasMatch(patientAgeController.text))) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('History')
          .doc(id)
          .set({
        'hospital_name': widget.hospitalName,
        'id': id,
        'timestamp': now,
        'isAdmitted': false,
      });
      await FirebaseFirestore.instance
          .collection('hospital_names')
          .doc(widget.hospitalUid)
          .collection('Patients')
          .doc(id)
          .set({
        'name': patientNameController.text.toString(),
        'address': patientAddressController.text.toString(),
        'age': patientAgeController.text.toString(),
        'phone_no': patientPhoneController.text.trim().toString(),
        'timestamp': now,
        'patient_uid': _auth.currentUser!.uid,
        'id': id,
        'isAdmitted': false,
      }).then((value) {
        Utils().toastMsg("Successful");
        patientNameController.clear();
        patientAddressController.clear();
        patientPhoneController.clear();
        patientAgeController.clear();
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
    patientNameController.dispose();
    patientAddressController.dispose();
    patientAgeController.dispose();
    patientPhoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.hospitalName,
          style: appBarTitleTextStyle,
        ),
        backgroundColor: allBgClr,
        centerTitle: true,
        elevation: 0,
        leading: const AppBarBackBtn(),
      ),
      backgroundColor: allBgClr,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: size.height * 0.05,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: MyCard(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Hi it's dr.${widget.drName}",style: cardInfoTextStyle,),
                    Text("Specialist of ${widget.speciality}",style: cardInfoTextStyle,),
                    Text("Earned degrees ${widget.degree}",style: cardInfoTextStyle,),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.04,
            ),
            const Divider(),
            SizedBox(
              height: size.height * 0.03,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 350,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: decoration,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DataInputCard(
                        name: "Name:",
                        controller: patientNameController,
                      ),
                      DataInputCard(
                        name: "Address:",
                        controller: patientAddressController,
                      ),
                      DataInputCard(
                        name: "Phone Number:",
                        hintText: "Enter 10 digit number",
                        controller: patientPhoneController,
                        keyBoardType: TextInputType.number,
                      ),
                      DataInputCard(
                        name: "Age:",
                        controller: patientAgeController,
                        keyBoardType: TextInputType.number,
                      ),
                      MyCardButton(
                        btnName: "     Book     ",
                        shap: regularStyle,
                        press: () {
                          bookHospitalBed();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
