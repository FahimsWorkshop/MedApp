import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:medapp/ui/animations/route.dart';
import 'package:medapp/ui/doctor/ui.dart';
import 'package:medapp/utils/uiHelpers.dart';

/// doctors.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 09 Feb, 2021 3:29 AM


class Doctors extends StatelessWidget {
  final int size;
  final List<dynamic> doctors;

  Doctors({this.size, this.doctors});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: this.getChildren(context),
    );
  }

  List<Widget> getChildren(BuildContext context) {
    List< Widget> children = [];

    for (var index = 0; index < this.doctors.length; index++) {
      dynamic doctor = this.doctors[index];
      children.add(
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white
            ),
            child: InkWell(
              onTap: () async {
                Navigator.of(context).push(
                  rightToLeft(DoctorUI(doctorID: doctor.id, isScheduled: false,))
                );
              },
              child: Row(
                children: [
                  Hero(
                    tag: doctor.id,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(doctor['PhotoURL']),
                      radius: 35,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doctor['Name'],
                            style: TextStyle(
                                color: Colors.blueGrey.shade600,
                                letterSpacing: 1,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            doctor['Field'],
                            style: TextStyle(
                                color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      doctor['Reviews'].length != 0 && doctor['Rating'] != 0 ? Row(
                        children: [
                          getRateIcons(doctor['Rating'], padding: EdgeInsets.all(0), spaceBetween: 0, size: 15),
                          SizedBox(width: 5,),
                          Text(doctor['Rating'].toString(), style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
                          SizedBox(width: 3,),
                          Container(width: 1.5, height: 11, color: Colors.grey.shade300,),
                          SizedBox(width: 5,),
                          doctor['Reviews'].length == 1 ?
                          Text(doctor['Reviews'].length.toString() + " Review", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),) :
                          Text(doctor['Reviews'].length.toString() + " Reviews", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),),
                        ],
                      ): Text("No reviews yet", style: TextStyle(fontSize: 12, color: Colors.black26, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ],
              ),
            ),
          )
      );
    }

    return children;
  }
}

