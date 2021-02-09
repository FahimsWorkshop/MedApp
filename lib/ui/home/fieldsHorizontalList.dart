import 'package:flutter/material.dart';

/// fieldsHorizontalList.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 09 Feb, 2021 4:47 AM


class FieldsHorizontalList extends StatelessWidget {
  final List<dynamic> fields;

  FieldsHorizontalList({this.fields});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      itemCount: this.fields.length,
      itemBuilder: (BuildContext context, int index) {
        var field = this.fields[index];
        return FlatButton(
          onPressed: null,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blueAccent.shade100,
                child: Icon(field['icon']),
              ),
              SizedBox(width: 5,),
              Text(field['name'], style: TextStyle(
                color: Colors.blueGrey.shade600,
                fontWeight: FontWeight.bold
              ),)
            ],
          ),
        );
      },
    );
  }
}
