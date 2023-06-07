import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_medcare/screens/users/bloodbank/book_blood_bank_screen.dart';
import 'package:new_medcare/widgets/my_card.dart';
import '../../../utils/decoration.dart';
import '../../../utils/toast_msg.dart';
import '../../../widgets/my_card_btn.dart';

class BloodBankScreen extends StatefulWidget {
  const BloodBankScreen({Key? key}) : super(key: key);

  @override
  State<BloodBankScreen> createState() => _BloodBankScreenState();
}

class _BloodBankScreenState extends State<BloodBankScreen> {
  final firestore =
      FirebaseFirestore.instance.collection('Blood_Bank').snapshots();
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
              child: CircularProgressIndicator(color: Colors.blue));
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
                          snapshot.data!.docs[index]['BloodBankName']
                              .toString(),
                          style: cardNameTextStyle),
                      Divider(color: dividerClr),
                      Text(
                          "Contact: ${snapshot.data!.docs[index]['BloodBankPhone'].toString()}",
                          style: cardInfoTextStyle),
                      Text(
                          "Address: ${snapshot.data!.docs[index]['BloodBankAddress'].toString()}",
                          style: cardInfoTextStyle),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: MyCardButton(
                          btnName: "     Order     ",
                          shap: regularStyle,
                          press: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BloodBankBookingScreen(
                                      bloodBankName: snapshot
                                          .data!.docs[index]['BloodBankName']
                                          .toString(),
                                      bloodBankUid: snapshot
                                          .data!.docs[index]['BloodBankUid']
                                          .toString()),
                                ));
                          },
                        ),
                      )
                    ],
                  ),
                );
              });
        }
      },
    );
  }
}