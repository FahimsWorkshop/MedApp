import 'package:flutter/material.dart';
import 'package:medapp/ui/animations/route.dart';
import 'package:medapp/ui/doctor/ui.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../sign_in.dart';

/// ui.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 14 Feb, 2021 2:20 AM


class AppointmentsUI extends StatefulWidget {
  @override
  _AppointmentsUIState createState() => _AppointmentsUIState();
}

class _AppointmentsUIState extends State<AppointmentsUI> {
  List<dynamic> appointments;
  bool isLoading = false;
  int totalAppointments = 0;

  Future<void> loadData() async {
    setState(() {
      this.isLoading = true;
    });
    Query appointmentsReference = FirebaseFirestore.instance.collection('Appointments').where('User', isEqualTo: uid).orderBy("Timestamp", descending: false);

    appointmentsReference.snapshots().listen((event) {
      setState(() {
        this.appointments = event.docs;
        this.totalAppointments = event.size;
        this.isLoading = false;
      });
    });
  }

  @override
  void initState() {
    this.loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return this.isLoading ? Center(child: CircularProgressIndicator(),) : ListView.builder(
        itemCount: this.appointments.length,
        itemBuilder: (BuildContext context, int index) {
          var appointment = this.appointments[index];
          return Container(
            decoration: BoxDecoration(
                color: Colors.blue.shade700,
                borderRadius: BorderRadius.circular(30)),
            margin: EdgeInsets.only(right: 20, left: 20, bottom: 10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage:
                          NetworkImage(appointment['DoctorPhotoUrl']),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment['DoctorName'],
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  fontSize: 18),
                            ),
                            Text(
                              appointment['DoctorField'],
                              style: TextStyle(
                                  color: Colors.blue.shade300, fontSize: 15),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                FlatButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  color: Colors.blue.shade800,
                  onPressed: () async {
                    Navigator.of(context).push(
                        rightToLeft(DoctorUI(doctorID: appointment['Doctor'], isScheduled: true, appointmentID: appointment.id,))
                    );
                  },
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.blue.shade200,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          DateFormat.yMMMd().add_jm().format(DateTime.parse(
                              appointment['Timestamp'].toDate().toString())),
                          style: TextStyle(
                              color: Colors.blue.shade200,
                              fontSize: 18,
                              fontWeight: FontWeight.normal),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
    );
  }
}

