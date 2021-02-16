import 'package:flutter/material.dart';
import 'package:zoton/ui/core/app_bar.dart';

/// search.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 16 Feb, 2021 9:15 AM

class AmbulanceDetailsUI extends StatelessWidget {
  final dynamic ambulance;

  AmbulanceDetailsUI({this.ambulance});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generalAppBar(
          title: Text(
        "Ambulance",
        style: TextStyle(color: Colors.black87),
      )),
      body: SingleChildScrollView(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30), color: Colors.white),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SelectableText(
                      ambulance['Provider'],
                      style: TextStyle(
                          color: Colors.blueGrey.shade600,
                          letterSpacing: 1,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SelectableText(
                      ambulance['Area'],
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    SelectableText(
                      ambulance['Contact_Number'],
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 15,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ]))),
    );
  }
}
