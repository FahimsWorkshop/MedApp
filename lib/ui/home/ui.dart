import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:zoton/login_page.dart';
import 'package:zoton/sign_in.dart';
import 'package:zoton/ui/ambulance/ui.dart';
import 'package:zoton/ui/animations/route.dart';
import 'package:zoton/ui/appointments/ui.dart';
import 'package:zoton/ui/articles/ui.dart';
import 'package:zoton/ui/blood_donation/ui.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zoton/ui/home/home.dart';
import 'package:zoton/ui/medicine/ui.dart';
import 'package:zoton/ui/profile/ui.dart';
import 'package:splashscreen/splashscreen.dart';



/// ui.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 08 Feb, 2021 6:35 PM


class UI extends StatefulWidget {
  final FirebaseApp firebaseAppInstance;

  UI({this.firebaseAppInstance});

  @override
  _UIState createState() => _UIState();
}

class _UIState extends State<UI> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  List<QueryDocumentSnapshot> doctors;
  List<QueryDocumentSnapshot> appointments;
  int totalAppointments = 0;
  bool isLoading = false;

  List<Map<String, dynamic>> fields = [
    {"name": "Relevant"},
    {"name": "Heart Surgeon"},
    {"name": "Psychologist"},
  ];

  int index = 0;

  final List<Widget> pages = [
    HomeUI(),
    AppointmentsUI(),
    ProfileUI()
  ];
  
  @override
  void initState() {
    this._firebaseMessaging.subscribeToTopic("medicineReminder");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('ZOTON', style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30
              ),),
              decoration: BoxDecoration(
                color: Colors.blue.shade800,
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.opacity_outlined,),
                  SizedBox(width: 5,),
                  Text("Blood Donations")
                ],
              ),
              onTap: () async {
                this.isLoading = false;
                Navigator.of(context).push(
                    rightToLeft(BloodDonationUI())
                );
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.medical_services_outlined,),
                  SizedBox(width: 5,),
                  Text("Ambulances")
                ],
              ),
              onTap: () {
                this.isLoading = false;
                Navigator.of(context).push(
                    rightToLeft(AmbulancesUI())
                );
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.healing_outlined,),
                  SizedBox(width: 5,),
                  Text("Medicines")
                ],
              ),
              onTap: () {
                this.isLoading = false;
                Navigator.of(context).push(
                    rightToLeft(MedicineUI())
                );
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.article_outlined,),
                  SizedBox(width: 5,),
                  Text("Articles")
                ],
              ),
              onTap: () {
                this.isLoading = false;
                Navigator.of(context).push(
                    rightToLeft(ArticleUI())
                );
              },
            ),
            SizedBox(height: 50,),
            ListTile(
              title: Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 5,),
                  Text("Logout")
                ],
              ),
              onTap: () async {
                await signOutGoogle();

                this.isLoading = false;
                Navigator.of(context).pushAndRemoveUntil(
                    rightToLeft(LoginPage()),
                        (Route<dynamic> route) => false
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: this.index,
        onTap: (int i) {
          setState(() {
            this.index = i;
          });
        },
        elevation: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: "Appointments"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile"),
        ],
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blueGrey),
        toolbarHeight: 60,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(name, style: TextStyle(color: Colors.black87),),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 25,
            child: CircleAvatar(backgroundImage: NetworkImage(imageUrl),),
          ),
          SizedBox(width: 10,)
        ],
      ),
      body: this.pages[this.index],
    );
  }
}
