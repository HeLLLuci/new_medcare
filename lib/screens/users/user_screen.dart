import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_medcare/screens/users/ambulance/ambulance_screen.dart';
import 'package:new_medcare/screens/users/bloodbank/blood_bank_screen.dart';
import 'package:new_medcare/screens/users/hospitals/hospital_screen.dart';
import '../../utils/decoration.dart';
import '../../utils/toast_msg.dart';
import 'history.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int _currentIndex = 0;

  List pages = [
    const HospitalScreen(),
    const BloodBankScreen(),
    const AmbulanceScreen(),
    const HistoryScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("MedCare",style: medCareTextStyle),
        backgroundColor: allBgClr,
        leading: Container(),
        centerTitle: true,
        elevation: 0,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert,color: Colors.blueGrey),
            color: allBgClr,
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 3,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*0.35,
                    child: ListTile(
                      trailing: const Icon(Icons.logout,color: Colors.red),
                      title: const Text("Logout"),
                      onTap: () {
                        Navigator.pop(context);
                        Utils().dialog(context);
                      },
                    ),
                  )
              )
            ],
          ),
        ],
      ),
      backgroundColor: allBgClr,
      body: pages[_currentIndex],

      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: false,
        containerHeight: 70,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        iconSize: 30,
        backgroundColor: Colors.transparent,
        itemCornerRadius: 25,
        curve: Curves.easeInOutCubicEmphasized,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(MdiIcons.hospitalBuilding),
            title: Text('Hospital',style: navBarTextStyle),
            activeColor: blueBtnClr,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(MdiIcons.bloodBag),
            title: Text('BloodBank',style: navBarTextStyle),
            activeColor: blueBtnClr,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon:  const Icon(MdiIcons.ambulance),
            title: Text('Ambulance',style: navBarTextStyle),
            activeColor: blueBtnClr,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon:  const Icon(MdiIcons.history),
            title: Text('History',style: navBarTextStyle),
            activeColor: blueBtnClr,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}