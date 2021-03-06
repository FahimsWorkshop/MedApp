import 'package:flutter/material.dart';

/// doctorsActions.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 09 Feb, 2021 3:59 AM


class DoctorsActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Let's find your doctor", style: TextStyle(color: Colors.blueGrey.shade600, fontSize: 20, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
