import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../utils/decoration.dart';
import '../../../utils/toast_msg.dart';
import '../../../widgets/app_bar_back_btn.dart';
import '../../../widgets/data_input_card.dart';
import '../../../widgets/my_card_btn.dart';

class BloodBankBookingScreen extends StatefulWidget {
  final String bloodBankUid;
  final String bloodBankName;
  const BloodBankBookingScreen({Key? key, required this.bloodBankUid, required this.bloodBankName}) : super(key: key);

  @override
  State<BloodBankBookingScreen> createState() => _BloodBankBookingScreenState();
}

class _BloodBankBookingScreenState extends State<BloodBankBookingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  String? selectedValue;
  bool isBloodSelected = false;
  DateTime now = DateTime.now();
  List<String> domain = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-',];

  void orderBloodBag() async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    if(_formKey.currentState!.validate()
        && (nameController.text.isNotEmpty
            && RegExp(r'^[a-z A-Z]+$').hasMatch(nameController.text))
        && (addressController.text.isNotEmpty
            && RegExp(r'^[a-z A-Z0-9]+$').hasMatch(addressController.text))
        && (phoneController.text.isNotEmpty
            && RegExp(r'^(?:[+0]9)?[0-9]{10}$').hasMatch(phoneController.text.trim()))
        && (ageController.text.isNotEmpty
            && RegExp(r'^[0-9]+$').hasMatch(ageController.text))
        && (isBloodSelected)
    )  {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('History')
          .doc(id).set({
        'hospital_name': widget.bloodBankName,
        'id': id,
        'timestamp': now,
        'isAdmitted': false,
      });
      await FirebaseFirestore.instance
          .collection('Blood_Bank')
          .doc(widget.bloodBankUid)
          .collection('Patients')
          .doc(id).set({
        'PatientName': nameController.text.toString(),
        'PatientAddress': addressController.text.toString(),
        'PatientAge': ageController.text.toString(),
        'PatientPhone': phoneController.text.trim().toString(),
        'PatientBloodGroup': selectedValue.toString(),
        'isAdmitted': false,
        'patient_uid': _auth.currentUser!.uid,
        'timestamp': now,
        'id': id,
      }).then((value) {
        Utils().toastMsg("Successful");
        nameController.clear();
        addressController.clear();
        ageController.clear();
        phoneController.clear();
        setState(() {
          isBloodSelected = false;
          selectedValue = null;
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
    nameController.dispose();
    addressController.dispose();
    ageController.dispose();
    phoneController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order a blood bag",style: appBarTitleTextStyle,),
        backgroundColor: allBgClr,
        centerTitle: true,
        elevation: 0,
        leading: const AppBarBackBtn(),
      ),
      backgroundColor: allBgClr,
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*0.1),
            Container(
              height: 400,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              alignment: Alignment.center,
              decoration: decoration,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DataInputCard(
                      name: "Name:",
                      controller: nameController,
                    ),
                    DataInputCard(
                      name: "Address:",
                      controller: addressController,
                    ),
                    DataInputCard(
                      name: "Phone Number:",
                      hintText: "Enter 10 digit number",
                      controller: phoneController,
                      keyBoardType: TextInputType.number,
                    ),
                    DataInputCard(
                      name: "Age:",
                      controller: ageController,
                      keyBoardType: TextInputType.number,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Expanded(
                          flex: 4,
                          child: Text(
                            "Blood Group:",
                              style:  TextStyle(fontSize: 18,color: Color(0xFF474E68))
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: allBgClr,
                                border: Border.all(color: Colors.grey)),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                elevation: 9,
                                dropdownColor: Colors.white.withOpacity(.9),
                                icon: const Icon(Icons.arrow_downward,
                                    color: Colors.black54),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black87),
                                value: selectedValue,
                                items: domain.map((name) {
                                  return DropdownMenuItem<String>(
                                      value: name, child: Text(name.toString()));
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedValue = newValue.toString();
                                    isBloodSelected = true;
                                  });
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    MyCardButton(
                      btnName: "     Order     ",
                      shap: regularStyle,
                      press: () {
                        orderBloodBag();
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.1),
          ]
        ),
      ),
    );
  }
}