import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_medcare/widgets/my_card.dart';
import '../../../utils/decoration.dart';
import '../../../utils/toast_msg.dart';

class BloodBankPatientCard extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final int index;
  const BloodBankPatientCard({Key? key, required this.snapshot, required this.index}) : super(key: key);

  @override
  State<BloodBankPatientCard> createState() => _BloodBankPatientCardState();
}

class _BloodBankPatientCardState extends State<BloodBankPatientCard> {

  final _auth = FirebaseAuth.instance;
  final firestoreUser = FirebaseFirestore.instance.collection('users');
  final firestoreHospitalNames = FirebaseFirestore.instance.collection('Blood_Bank');
  final firestoreBBPatientInfo = FirebaseFirestore.instance
      .collection('Blood_Bank')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Patients');

  void availabilityStatus(patientUid,patientTimeStampId) async {
    await  firestoreHospitalNames.doc(_auth.currentUser!.uid).collection('Patients')
        .doc(patientTimeStampId).update({
      'isAdmitted': true,
    });
    await firestoreUser.doc(patientUid).collection('History')
        .doc(patientTimeStampId).update({
      'isAdmitted': true,
    }).then((value) {
      Utils().toastMsg("blood bag availability conveyed");
    }).onError((error, stackTrace) async {
      await firestoreBBPatientInfo.doc(patientTimeStampId).update({
        'isAdmitted': false,
      });
      if (error is FirebaseException && error.code == 'not-found') {
        Utils().toastMsg("Patient's registration canceled");
      } else {
        Utils().toastMsg("Something went wrong");
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size;
    return MyCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${widget.snapshot.data!.docs[widget.index]['PatientName'].toString()}"
                ,style: cardNameTextStyle),
            Divider(color: dividerClr),
            Text("Blood Group: ${widget.snapshot.data!.docs[widget.index]['PatientBloodGroup'].toString()}"
                ,style: cardInfoTextStyle),
            Text("Contact: ${widget.snapshot.data!.docs[widget.index]['PatientPhone'].toString()}"
                ,style: cardInfoTextStyle),
            Text("Age: ${widget.snapshot.data!.docs[widget.index]['PatientAge'].toString()}"
                ,style: cardInfoTextStyle),
            Text(
              DateFormat.yMMMd() .format (
                widget.snapshot.data!.docs[widget.index]['timestamp'].toDate(),
              ),
              style: cardInfoTextStyle,
            ),
            Text("Address: ${widget.snapshot.data!.docs[widget.index]['PatientAddress'].toString()}"
                ,style: cardInfoTextStyle),
            Align(
                alignment: Alignment.bottomRight,
                child:ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          widget.snapshot.data!.docs[widget.index]['isAdmitted'] == true
                              ? Colors.green : Colors.red
                      ),
                      shape: regularStyle,
                    ),
                    onPressed: (){
                      final patientUid = widget.snapshot.data!.docs[widget.index]['patient_uid'];
                      final patientTimeStampId =widget.snapshot.data!.docs[widget.index]['id'].toString();
                      availabilityStatus(patientUid,patientTimeStampId);
                    },
                    child: const Text("    Accept    ",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white
                      ),)
                )
            )
          ],
        ),
    );
  }
}
