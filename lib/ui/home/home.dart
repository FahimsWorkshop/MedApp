import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:zoton/sign_in.dart';
import 'package:zoton/ui/animations/route.dart';
import 'package:zoton/ui/blood_donation/ui.dart';
import 'package:zoton/ui/home/appointmentActions.dart';
import 'package:zoton/ui/home/appointments.dart';
import 'package:zoton/ui/home/doctors.dart';
import 'package:zoton/ui/home/doctorsActions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zoton/ui/home/navigationGrids.dart';

/// home.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 14 Feb, 2021 2:29 AM


class HomeUI extends StatefulWidget {
  @override
  _HomeUIState createState() => _HomeUIState();
}

class _HomeUIState extends State<HomeUI> {

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  List<QueryDocumentSnapshot> doctors;
  List<QueryDocumentSnapshot> appointments;
  int totalAppointments = 0;
  bool isLoading = false;

  List<Map<String, dynamic>> fields = [
    {"name": "Relevant"},
    {"name": "Heart Surgeon"},
    {"name": "Dermatology"},
    {"name": "Cardiology"},
    {"name": "Medicine"},
  ];

  @override
  void initState() {
    this.printToken();
    this.loadData();
    super.initState();
    this._firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
          showDialog(
              context: this.context,
              builder: (BuildContext context) => AlertDialog(
                title: Text(message["notification"]["title"]),
                content: Text(message["notification"]["body"]),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  FlatButton(
                    child: Text(
                      "Close",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  FlatButton(
                      child: Text("Response"),
                      onPressed: () async {
                        Navigator.of(context)
                            .push(rightToLeft(BloodDonationUI()));
                      }),
                ],
              ));
        });
  }
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: loadData,
      child: !this.isLoading ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: NavigationGrid(),
            )),
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
    );
  }

  Future<void> loadData() async {
    setState(() {
      this.isLoading = true;
    });
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


  Future<void> printToken() async {
    print(await this._firebaseMessaging.getToken());
  }
}

