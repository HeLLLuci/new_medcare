import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_medcare/screens/users/hospitals/seat_booking_screen.dart';
import 'package:new_medcare/utils/toast_msg.dart';
import 'package:new_medcare/widgets/my_card.dart';
import '../../../utils/decoration.dart';
import '../../../widgets/my_card_btn.dart';

class HospitalScreen extends StatefulWidget {
  const HospitalScreen({Key? key}) : super(key: key);

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> {
  final firestore =
      FirebaseFirestore.instance.collection('hospital_names').snapshots();
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
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.blue,
          ));
        }
        if (snapshot.hasError) {
          Utils().toastMsg("Something went wrong");
        }
        if (snapshot.data!.docs.isEmpty) {
          return ListView(
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              Image.asset("assets/images/doctor.png"),
              SizedBox(
                height: size.height * 0.05,
              ),
              Center(
                child: Text(
                  "No Data Found",
                  style: noDataTextStyle,
                ),
              ),
            ],
          );
        } else {
          return ListView.builder(
              controller: scrollController,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return MyCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          snapshot.data!.docs[index]['Hospital_name']
                              .toString(),
                          style: cardNameTextStyle),
                      Divider(color: dividerClr),
                      Text(
                          "Contact: ${snapshot.data!.docs[index]['Hospital_phone'].toString()}",
                          style: cardInfoTextStyle),
                      Text(
                          "Address: ${snapshot.data!.docs[index]['Hospital_address'].toString()}",
                          style: cardInfoTextStyle),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: MyCardButton(
                            btnName: "     Book     ",
                            shap: regularStyle,
                            press: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SeatBookingScreen(
                                      hospitalUid: snapshot
                                          .data!.docs[index]['Hospital_uid']
                                          .toString(),
                                      hospitalName: snapshot
                                          .data!.docs[index]['Hospital_name']
                                          .toString(),
                                      drName: snapshot
                                          .data!.docs[index]['Dr_Name']
                                          .toString(),
                                      speciality: snapshot
                                          .data!.docs[index]['Speciality']
                                          .toString(),
                                      degree: snapshot
                                          .data!.docs[index]['Degree']
                                          .toString(),
                                    ),
                                  ));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        }
      },
    );
  }
}