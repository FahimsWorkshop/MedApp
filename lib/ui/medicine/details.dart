import 'package:flutter/material.dart';
import 'package:zoton/ui/core/app_bar.dart';
import 'package:readmore/readmore.dart';

/// details.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 16 Feb, 2021 10:23 AM


class MedicineDetailsUI extends StatelessWidget {
  final dynamic medicine;

  MedicineDetailsUI({this.medicine});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generalAppBar(
          title: Text(
            "Medicine",
            style: TextStyle(color: Colors.black87),
          )),
      body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30), color: Colors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      this.medicine['Name'],
                      style: TextStyle(
                          color: Colors.blueGrey.shade600,
                          letterSpacing: 1,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      this.medicine['Contains'],
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      this.medicine['Manufacturer'],
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  this.medicine['Medicine_For'],
                  style: TextStyle(
                      color: Colors.grey.shade900,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10,),
                Text(
                  "Instruction",
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                ReadMoreText(
                  this.medicine['Instruction'],
                  trimLines: 5,
                  colorClickableText: Colors.blue.shade700,
                  trimMode: TrimMode.Line,
                  trimCollapsedText: 'Show more',
                  trimExpandedText: 'Show less',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 10,),
                Text(
                  medicine['Price'],
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }
}

