import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:medapp/ui/animations/route.dart';
import 'package:medapp/ui/articles/details.dart';
import 'package:medapp/ui/blood_donation/details_ui.dart';
import 'package:medapp/ui/core/app_bar.dart';

/// ui.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 14 Feb, 2021 2:46 AM

class ArticleUI extends StatefulWidget {
  @override
  _ArticleUIState createState() => _ArticleUIState();
}

class _ArticleUIState extends State<ArticleUI> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool isLoading = false;
  List<QueryDocumentSnapshot> articles;
  int size;
  String contactDetails = "";
  String purpose = "";
  String bloodGroup = "";
  String userToken = "";

  @override
  void initState() {
    this.loadDonationRequests();
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
                            .push(rightToLeft(BloodDonationDetailsUI(boodDonationId: message["data"]["id"], userToken: this.userToken,)));
                      }),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generalAppBar(
          title: Text(
        "Articles",
        style: TextStyle(color: Colors.black87),
      )),
      body: this.isLoading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
          child: Column(
            children: this.getChildren(context),
          )
      ),
    );
  }

  Future<void> loadDonationRequests() async {
    setState(() {
      this.isLoading = true;
      this._firebaseMessaging.getToken().then((value) => this.userToken = value);
    });

    CollectionReference bloodDonationCollectionRefrence =
    FirebaseFirestore.instance.collection('Articles');

    bloodDonationCollectionRefrence.snapshots().listen((event) {
      setState(() {
        this.articles = event.docs;
        this.size = event.size;
        this.isLoading = false;
      });
    });
  }

  List<Widget> getChildren(BuildContext context) {
    List<Widget> children = [];

    for (var index = 0; index < this.size; index++) {
      dynamic article = this.articles[index];
      children.add(Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.white),
        child: InkWell(
          onTap: () async {
            Navigator.of(context).push(
                rightToLeft(ArticleDetailsUI(article: article,))
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article['Title'],
                    style: TextStyle(
                        color: Colors.blueGrey.shade600,
                        letterSpacing: 1,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    article["By_Name"],
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  FlatButton(
                    onPressed: () {},
                    color: Colors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    child: Text(article["Topic"], style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                  ),
                  Text(
                    DateFormat.yMMMd().add_jm().format(DateTime.parse(
                        article['Timestamp'].toDate().toString())),
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ));
    }

    return children;
  }
}
