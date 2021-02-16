import 'package:flutter/material.dart';
import 'package:zoton/ui/ambulance/ui.dart';
import 'package:zoton/ui/animations/route.dart';
import 'package:zoton/ui/articles/ui.dart';
import 'package:zoton/ui/blood_donation/ui.dart';
import 'package:zoton/ui/medicine/ui.dart';

/// navigationGrids.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 16 Feb, 2021 11:06 AM


class NavigationGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      childAspectRatio: 1.5,
      shrinkWrap: true,
      crossAxisCount: 2,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)
            ),
            child: InkWell(
              onTap: () async {
                Navigator.of(context).push(
                    rightToLeft(BloodDonationUI())
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.opacity_outlined, size: 40, color: Colors.redAccent,),
                  SizedBox(height: 5,),
                  Text("Blood Donations", style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            child: InkWell(
              onTap: () async {
                Navigator.of(context).push(
                    rightToLeft(AmbulancesUI())
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medical_services_outlined, size: 40, color: Colors.blueAccent,),
                  SizedBox(height: 5,),
                  Text("Ambulance", style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            child: InkWell(
              onTap: () async {
                Navigator.of(context).push(
                    rightToLeft(MedicineUI())
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.healing_outlined, size: 40, color: Colors.indigo,),
                  SizedBox(height: 5,),
                  Text("Medicines", style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
            ),
            child: InkWell(
              onTap: () async {
                Navigator.of(context).push(
                    rightToLeft(ArticleUI())
                );
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.article_outlined, size: 40, color: Colors.teal,),
                  SizedBox(height: 5,),
                  Text("Articles", style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          ),
        ),
      ]
    );
  }
}

