import 'package:flutter/material.dart';
import 'package:medapp/ui/core/app_bar.dart';
import 'package:intl/intl.dart';

/// details.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 14 Feb, 2021 2:46 AM


class ArticleDetailsUI extends StatelessWidget {
  final dynamic article;

  ArticleDetailsUI({this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generalAppBar(
          title: Text(
            "Article",
            style: TextStyle(color: Colors.black87),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                this.article['Title'],
                style: TextStyle(
                    color: Colors.blueGrey.shade600,
                    letterSpacing: 1,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              Text(
                this.article["By_Name"],
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10,),
              FlatButton(
                onPressed: () {},
                color: Colors.grey,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Text(this.article["Topic"], style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 10,),
              Text(
                DateFormat.yMMMd().add_jm().format(DateTime.parse(
                    this.article['Timestamp'].toDate().toString())),
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20,),
              Text(
                this.article["Body"],
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
              )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

