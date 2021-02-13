import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medapp/ui/core/app_bar.dart';

/// details_ui.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 13 Feb, 2021 10:49 PM

class BloodDonationDetailsUI extends StatefulWidget {
  final String boodDonationId;
  final String userToken;

  BloodDonationDetailsUI({this.boodDonationId, this.userToken});

  @override
  _BloodDonationDetailsUIState createState() => _BloodDonationDetailsUIState();
}

class _BloodDonationDetailsUIState extends State<BloodDonationDetailsUI> {
  Map<String, dynamic> data;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    this.getBloodDonationDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: generalAppBar(
          title: Text(
        "Responses",
        style: TextStyle(color: Colors.black87),
      )),
      body: this.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: this.widget.boodDonationId,
                          child: CircleAvatar(
                            backgroundColor:
                                data['done'] ? Colors.green : Colors.red,
                            radius: 25,
                            child: Text(
                              data["Group"],
                              style: TextStyle(
                                  color: data['done']
                                      ? Colors.green.shade900
                                      : Colors.red.shade900,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['By_Name'],
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade600,
                                      letterSpacing: 1,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  DateFormat.yMMMd().add_jm().format(
                                      DateTime.parse(data['Timestamp']
                                          .toDate()
                                          .toString())),
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              data['Accepts'].length.toString() +
                                  " Response(s)",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              data["Purpose"],
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: this.widget.userToken == data["User"]
                        ? FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color:
                                this.data["done"] ? Colors.red : Colors.green,
                            child: Text(
                              this.data["done"] ? "Not Satisfied" : "Satisfied",
                              style: TextStyle(
                                  color: this.data["done"]
                                      ? Colors.red.shade100
                                      : Colors.green.shade100),
                            ),
                            onPressed: () async {
                              setState(() {
                                this.isLoading = true;
                              });
                              DocumentReference bloodDocumentRefrence =
                                  FirebaseFirestore.instance
                                      .collection('Blood_Donation')
                                      .doc(this.widget.boodDonationId);
                              await bloodDocumentRefrence.update(
                                  {"done": this.data["done"] ? false : true});
                              setState(() {
                                this.isLoading = false;
                              });
                            },
                          )
                        : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: this.widget.userToken == data["User"]
                        ? FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            color: Colors.red,
                            child: Text(
                              "Delete",
                              style: TextStyle(color: Colors.red.shade100),
                            ),
                            onPressed: () async {
                              setState(() {
                                this.isLoading = true;
                              });
                              DocumentReference bloodDocumentRefrence =
                                  FirebaseFirestore.instance
                                      .collection('Blood_Donation')
                                      .doc(this.widget.boodDonationId);
                              await bloodDocumentRefrence.delete();
                              Navigator.of(context).pop();
                              setState(() {
                                this.isLoading = false;
                              });
                            },
                          )
                        : null,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Flexible(
                    child: Column(
                      children: this.getChildren(context),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Future<void> getBloodDonationDetails() async {
    setState(() {
      this.isLoading = true;
    });
    DocumentReference bloodDonation = FirebaseFirestore.instance
        .collection("Blood_Donation")
        .doc(this.widget.boodDonationId);

    bloodDonation.snapshots().listen((event) {
      setState(() {
        this.data = event.data();
        this.isLoading = false;
      });
    });
  }

  List<Widget> getChildren(BuildContext context) {
    List<Widget> children = [];
    if (this.isLoading == false) {
      for (var index = this.data["Accepts"].length - 1; index >= 0; index--) {
        dynamic response = this.data["Accepts"][index];
        children.add(Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30), color: Colors.white),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        response['Name'] != null ? response['Name'] : "",
                        style: TextStyle(
                            color: Colors.blueGrey.shade600,
                            letterSpacing: 1,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat.yMMMd().add_jm().format(DateTime.parse(
                            response['Timestamp'].toDate().toString())),
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Contact Details",
                    style: TextStyle(
                        color: Colors.black54,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  SelectableText(
                    response['Contact_Details'] != null
                        ? response['Contact_Details']
                        : "",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ],
          ),
        ));
      }
    }

    return children;
  }
}
