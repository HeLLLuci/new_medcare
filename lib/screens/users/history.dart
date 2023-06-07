import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_medcare/utils/toast_msg.dart';
import '../../../utils/decoration.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {

  final firestore = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('History').snapshots();

  CollectionReference collectionReference = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('History');

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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: firestore,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.blue,));
        }
        if (snapshot.hasError) {
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
          return ListView.builder(
            controller: scrollController,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(10.0),
                  decoration: decoration,
                  child: ListTile(
                    isThreeLine: true,
                    title: Text("Admitted to: "'${snapshot.data!.docs[index]['hospital_name'].toString()}'
                    ,style: historyHospitalNameTextStyle,
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat.yMMMd() .format (
                            snapshot.data!.docs[index]['timestamp'].toDate(),
                          ),
                          style: cardInfoTextStyle,
                        ),
                        Row(
                          children: [
                            Text("Approved : ",style: cardInfoTextStyle,),
                            snapshot.data!.docs[index]['isAdmitted'] == true
                                ? const Icon(MdiIcons.checkAll,color: Colors.green,size: 29,)
                                : Icon(MdiIcons.checkAll,color: Colors.grey.shade300,size: 29,)
                          ],
                        )
                      ],
                    ),
                    trailing: IconButton(
                      highlightColor: Colors.transparent,
                      onPressed: (){
                        final id = snapshot.data!.docs[index]['id'];
                        collectionReference.doc(id).delete();
                        Utils().toastMsg("Deleted");
                    }, icon: Icon(MdiIcons.delete,color: blueBtnClr,),),
                  ),
                );
              });
        }
      },
    );
  }
}