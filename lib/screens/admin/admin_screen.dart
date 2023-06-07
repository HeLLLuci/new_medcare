import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:new_medcare/screens/admin/bloodbank/Blood_patients_screen.dart';
import 'package:new_medcare/screens/admin/hospital/add_hospital.dart';
import 'package:new_medcare/utils/decoration.dart';
import 'ambulance/ambulance_screen.dart';
import 'bloodbank/blood_bank_screen.dart';
import 'package:new_medcare/utils/toast_msg.dart';

import 'hospital/patients_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}
class _AdminScreenState extends State<AdminScreen> {

int _currentIndex = 0;
List pages = [
  const PatientsScreen(),
  const BloodPatientsScreen(),
];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("MedCare",style: medCareTextStyle),
        centerTitle: true,
        backgroundColor: allBgClr,
        elevation: 0,
        leading: Container(),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert,color: Colors.blueGrey),
            color: allBgClr,
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 1,
                  child: ListTile(
                    trailing: const Icon(Icons.edit,color: Colors.brown,),
                    title: const Text("Hospital"),
                    onTap: () {
                      Navigator.pop(context);
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const AddHospital(),));
                    },
                  )
              ),
              PopupMenuItem(
                  value: 2,
                  child: ListTile(
                    trailing: const Icon(Icons.edit,color: Colors.brown),
                    title: const Text("BloodBank"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateBloodBankScreen(),));
                    },
                  )
              ),
              PopupMenuItem(
                  value: 2,
                  child: ListTile(
                    trailing: const Icon(Icons.edit,color: Colors.brown),
                    title: const Text("Ambulance"),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateAmbulanceScreen(),));
                    },
                  )
              ),
              PopupMenuItem(
                  value: 2,
                  child: ListTile(
                    trailing: const Icon(Icons.logout,color: Colors.red),
                    title: const Text("Logout"),
                    onTap: () {
                      Navigator.pop(context);
                      Utils().dialog(context);
                    },
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        iconSize: 30,
        backgroundColor: Colors.transparent,
        itemCornerRadius: 24,
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
        ],
      ),
    );
  }
}