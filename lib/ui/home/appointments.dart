import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zoton/ui/animations/route.dart';
import 'package:zoton/ui/doctor/ui.dart';

/// appointments.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 09 Feb, 2021 3:26 AM

class Appointments extends StatelessWidget {
  final List<dynamic> appointments;

  Appointments({this.appointments});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: this.appointments.length,
      itemBuilder: (BuildContext context, int index) {
        var appointment = this.appointments[index];
        return Container(
          width: 280,
          decoration: BoxDecoration(
              color: Colors.blue.shade700,
              borderRadius: BorderRadius.circular(30)),
          margin: EdgeInsets.only(right: 20, left: index == 0 ? 20 : 0),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      Container(
                        width: 190,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              appointment['DoctorName'],
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 1,
                                  fontSize: 16),
                            ),
                            Text(
                              appointment['DoctorField'],
                              style: TextStyle(
                                  color: Colors.blue.shade300, fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
              )
            ],
          ),
        );
      },
    );
  }
}
