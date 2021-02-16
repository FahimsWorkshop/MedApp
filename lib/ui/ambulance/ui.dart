import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:zoton/ui/ambulance/details.dart';
import 'package:zoton/ui/animations/route.dart';
import 'package:zoton/ui/blood_donation/details_ui.dart';
import 'package:zoton/ui/core/app_bar.dart';

/// ui.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 16 Feb, 2021 9:15 AM


class AmbulancesUI extends StatefulWidget {
  @override
  _AmbulancesUIState createState() => _AmbulancesUIState();
}

class _AmbulancesUIState extends State<AmbulancesUI> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool isLoading = false;
  List<QueryDocumentSnapshot> ambulances;
  int size;
  String contactDetails = "";
  String purpose = "";
  String bloodGroup = "";
  String userToken = "";
  bool isMine = false;

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
            "Ambulances",
            style: TextStyle(color: Colors.black87),
          )),
      body: this.isLoading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
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

    CollectionReference bloodDonationCollectionReference =
    FirebaseFirestore.instance.collection('Ambulances');

    bloodDonationCollectionReference.snapshots().listen((event) {
      setState(() {
        this.ambulances = event.docs;
        this.size = event.size;
        this.isLoading = false;
      });
    });
  }

  List<Widget> getChildren(BuildContext context) {
    List<Widget> children = [];

    for (var index = 0; index < this.size; index++) {
      dynamic ambulance = this.ambulances[index];
      children.add(InkWell(
        onTap: () async {
          Navigator.of(context).push(
              rightToLeft(AmbulanceDetailsUI(ambulance: ambulance,))
          );
        },
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
            ],
          ),
        ),
      ));
    }

    return children;
  }
}

