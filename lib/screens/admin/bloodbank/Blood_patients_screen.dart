import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_medcare/screens/admin/bloodbank/bb_patient_card.dart';
import 'package:new_medcare/utils/toast_msg.dart';
import 'package:new_medcare/widgets/search_bar.dart';
import '../../../utils/decoration.dart';

class BloodPatientsScreen extends StatefulWidget {
  const BloodPatientsScreen({Key? key}) : super(key: key);
  @override
  State<BloodPatientsScreen> createState() => _PatientsScareenState();
}

class _PatientsScareenState extends State<BloodPatientsScreen> {
  final firestore = FirebaseFirestore.instance.collection('Blood_Bank').doc(FirebaseAuth.instance.currentUser!.uid).collection('Patients').snapshots();
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
        stream: firestore,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(color: Colors.blue,));
          }
          if(snapshot.hasError){
            Utils().toastMsg("Something went wrong");
          }
          if(snapshot.data!.docs.isEmpty){
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
          }else{
            return Column(
              children: [
                MySearchBar(searchController: searchController,onChanged: (p0) {setState(() {});
                },),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final patientName = snapshot.data!.docs[index]['PatientName'].toString();
                      if(searchController.text.toString().isEmpty){
                      return BloodBankPatientCard(snapshot: snapshot,index: index,);
                      } else if(patientName.toLowerCase().contains(searchController.text.toLowerCase())){
                        return BloodBankPatientCard(snapshot: snapshot,index: index,);
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