import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:medapp/login_page.dart';
import 'package:medapp/sign_in.dart';
import 'package:medapp/ui/animations/route.dart';
import 'package:medapp/ui/home/appointmentActions.dart';
import 'package:medapp/ui/home/appointments.dart';
import 'package:medapp/ui/home/doctors.dart';
import 'package:medapp/ui/home/doctorsActions.dart';


/// ui.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 08 Feb, 2021 6:35 PM


class HomeUI extends StatefulWidget {
  final FirebaseApp firebaseAppInstance;

  HomeUI({this.firebaseAppInstance});

  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {

  List<QueryDocumentSnapshot> doctors;
  List<QueryDocumentSnapshot> appointments;
  int totalAppointments = 0;
  bool isLoading = false;

  List<Map<String, dynamic>> fields = [
    {"name": "Relevant"},
    {"name": "Heart Surgeon"},
    {"name": "Psychologist"},
  ];

  @override
  void initState() {
    this.loadData();
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
              child: Text('MedApp', style: TextStyle(
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
        elevation: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: "Appointments"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "Profile"),
        ],
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blueGrey),
        toolbarHeight: 80,
        backgroundColor: Color(0xfff1f1f1),
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
      body: RefreshIndicator(
        onRefresh: loadData,
        child: !this.isLoading ? SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20,),
              AppointmentActions(),
              SizedBox(height: 10,),
              this.totalAppointments != 0 ? Container(
                height: 190,
                child: Appointments(appointments: this.appointments,),
              ) : Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text("No appointments are scheduled"),
              ),
              SizedBox(height: 40,),
              DoctorsActions(),
              SizedBox(height: 10,),
              Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: this.fields.length,
                  itemBuilder: (BuildContext context, int index) {
                    var field = this.fields[index];
                    return Padding(
                      padding: EdgeInsets.only(right: 20, left: index == 0 ? 20 : 0),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            this.isLoading = true;
                          });

                          dynamic doctorsQuery;

                          if (index == 0) {
                            doctorsQuery =
                                FirebaseFirestore.instance.collection('Doctors');
                          }
                          else {
                            doctorsQuery =
                                FirebaseFirestore.instance.collection('Doctors')
                                    .where('Field', isEqualTo: field['name']);
                          }

                          doctorsQuery.snapshots().listen((event) {
                            setState(() {
                              this.doctors = event.docs;
                              this.isLoading = false;
                            });
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(field['name'], style: TextStyle(
                              color: Colors.blueGrey.shade600,
                              fontWeight: FontWeight.bold
                          ),),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10,),
              Flexible(
                child: Doctors(doctors: this.doctors, size: this.doctors.length,),
              )
            ],
          ),
        ) : Center(child: CircularProgressIndicator(),),
      ),
    );
  }

  Future<void> loadData() async {
    this.isLoading = true;
    CollectionReference doctorsReference = FirebaseFirestore.instance.collection('Doctors');
    Query appointmentsReference = FirebaseFirestore.instance.collection('Appointments').where('User', isEqualTo: uid).orderBy("Timestamp", descending: false);

    doctorsReference.snapshots().listen((event) {
      setState(() {
        this.doctors = event.docs;
      });
    });

    appointmentsReference.snapshots().listen((event) {
      setState(() {
        this.appointments = event.docs;
        this.totalAppointments = event.size;
        this.isLoading = false;
      });
    });
  }
}

