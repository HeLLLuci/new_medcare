import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:new_medcare/widgets/my_card.dart';
import '../../../utils/decoration.dart';
import '../../../utils/toast_msg.dart';

class PatientCard extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot<Object?>> snapshot;
  final int index;
  const PatientCard({Key? key, required this.snapshot, required this.index}) : super(key: key);

  @override
  State<PatientCard> createState() => _PatientCardState();
}

class _PatientCardState extends State<PatientCard> {

  final _auth = FirebaseAuth.instance;
  final firestoreUser = FirebaseFirestore.instance.collection('users');
  final firestoreHospitalNames = FirebaseFirestore.instance.collection('hospital_names');
  final firestorePatientsInfo = FirebaseFirestore.instance
      .collection('hospital_names')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Patients');
  void admittedStatus(patientUid,patientTimeStampId) async {
      await  firestoreHospitalNames.doc(_auth.currentUser!.uid).collection('Patients')
          .doc(patientTimeStampId).update({
        'isAdmitted': true,
      }).onError((error, stackTrace) {
          Utils().toastMsg("Something went wrong");
      });
      await firestoreUser.doc(patientUid).collection('History')
          .doc(patientTimeStampId).update({
        'isAdmitted': true,
      }).then((value) {
        Utils().toastMsg("Patient Admitted");
      }).onError((error, stackTrace) async {
        if (error is FirebaseException && error.code == 'not-found') {
        Utils().toastMsg("Patient's registration canceled");
        await firestorePatientsInfo.doc(patientTimeStampId).update({
          'isAdmitted': false,
        });
        } else {
        Utils().toastMsg("Something went wrong");
        }
      });

  }

  @override
  Widget build(BuildContext context) {
    return  MyCard(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${widget.snapshot.data!.docs[widget.index]['name'].toString()}",
                style: cardNameTextStyle),
            Divider(color: dividerClr),
            Text("Contact: ${widget.snapshot.data!.docs[widget.index]['phone_no'].toString()}",
                style: cardInfoTextStyle),
            Text("Age: ${widget.snapshot.data!.docs[widget.index]['age'].toString()}",
                style: cardInfoTextStyle),
            Text(
              DateFormat.yMMMd() .format (
                widget.snapshot.data!.docs[widget.index]['timestamp'].toDate(),
              ),
              style: cardInfoTextStyle,
            ),
            Text("Address: ${widget.snapshot.data!.docs[widget.index]['address'].toString()}",
                style: cardInfoTextStyle),
            Align(
                alignment: Alignment.bottomRight,
                child:ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:  MaterialStatePropertyAll(
                          widget.snapshot.data!.docs[widget.index]['isAdmitted'] == true
                              ? Colors.green : Colors.red
                      ),
                      shape: regularStyle,
                    ),
                    onPressed: (){
                      final patientUid = widget.snapshot.data!.docs[widget.index]['patient_uid'];
                      final patientTimeStampId =widget.snapshot.data!.docs[widget.index]['id'].toString();
                      admittedStatus(patientUid,patientTimeStampId);
                    },
                    child: const Text("     Admit     ",style: TextStyle(fontSize: 18,color: Colors.white),)
                )
            )
          ],
        ),
    );
  }
}
