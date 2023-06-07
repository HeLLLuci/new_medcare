import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:new_medcare/utils/toast_msg.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/decoration.dart';
import '../../../widgets/my_card.dart';
import '../../../widgets/my_card_btn.dart';

class AmbulanceScreen extends StatefulWidget {
  const AmbulanceScreen({Key? key}) : super(key: key);

  @override
  State<AmbulanceScreen> createState() => _AmbulanceScreenState();
}

class _AmbulanceScreenState extends State<AmbulanceScreen> {
  final firestore = FirebaseFirestore.instance.collection('Ambulance').snapshots();
  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    Future.delayed(const Duration(seconds: 1), () {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  void call(AsyncSnapshot<QuerySnapshot<Object?>> snapshot, int index) async {
    final phone = snapshot.data!.docs[index]['DriverPhoneNo'].toString();
    final Uri url = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      Utils().toastMsg("Cannot Connect");
    }
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
                          snapshot.data!.docs[index]['HospitalName']
                              .toString(),
                          style: cardNameTextStyle),
                      Divider(color: dividerClr),
                      Text(
                          "Driver Name: ${snapshot.data!.docs[index]['DriverName'].toString()}",
                          style: cardInfoTextStyle),
                      Text(
                          "Contact: ${snapshot.data!.docs[index]['DriverPhoneNo'].toString()}",
                          style: cardInfoTextStyle),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: MyCardButton(
                            btnName: "     Call     ",
                            shap: regularStyle,
                            press: () {
                              call(snapshot, index);
                            },
                          )
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
