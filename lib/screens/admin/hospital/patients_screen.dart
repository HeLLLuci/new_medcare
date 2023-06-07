import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_medcare/screens/admin/hospital/patient_card.dart';
import 'package:new_medcare/utils/toast_msg.dart';
import 'package:new_medcare/widgets/search_bar.dart';
import '../../../utils/decoration.dart';

class PatientsScreen extends StatefulWidget {
  const PatientsScreen({Key? key}) : super(key: key);
  @override
  State<PatientsScreen> createState() => _PatientsScareenState();
}

class _PatientsScareenState extends State<PatientsScreen> {

  TextEditingController searchController = TextEditingController();
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    Future.delayed(const Duration(seconds: 1), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  final firestoreStream = FirebaseFirestore.instance
      .collection('hospital_names')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('Patients')
      .snapshots();

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
        stream: firestoreStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.blue));
          }
          if (snapshot.hasError) {
            Utils().toastMsg("Something went wrong");
          }
          if (snapshot.data!.docs.isEmpty) {
            return ListView(
              children: [
                SizedBox(height: size.height*0.1,),
                Image.asset("assets/images/doctor.png"),
                SizedBox(height: size.height*0.05,),
                Center(
                  child: Text(
                    "No Data Found",
                    style: noDataTextStyle,
                  ),
                ),
              ],
            );
          } else {
            return Column(
              children: [
                MySearchBar(searchController: searchController,onChanged: (p0) {setState(() {});},),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final patientName = snapshot.data!.docs[index]['name'].toString();
                      if(searchController.text.toString().isEmpty){
                      return PatientCard(snapshot: snapshot, index: index);
                      }
                      else if(patientName.toLowerCase().contains(searchController.text.toLowerCase())){
                        return PatientCard(snapshot: snapshot, index: index);
                      }else{
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            );
          }
        },
    );
  }
}