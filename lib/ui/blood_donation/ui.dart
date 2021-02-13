import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:intl/intl.dart';
import 'package:medapp/services/fcm.dart';
import 'package:medapp/sign_in.dart';
import 'package:medapp/ui/animations/route.dart';
import 'package:medapp/ui/core/app_bar.dart';

import 'details_ui.dart';

/// ui.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 13 Feb, 2021 10:43 PM

class BloodDonationUI extends StatefulWidget {
  @override
  _BloodDonationUIState createState() => _BloodDonationUIState();
}

class _BloodDonationUIState extends State<BloodDonationUI> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool isLoading = false;
  List<QueryDocumentSnapshot> requests;
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          setState(() {
            this.isLoading = true;
          });
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text("Confirm"),
                  content: Column(
                    children: [
                      Text("Request blood donation?"),
                      SizedBox(height: 20,),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            this.purpose = value;
                          });
                        },
                        decoration: InputDecoration(
                            labelText: 'Request purpose'
                        ),
                      ),
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            this.bloodGroup = value;
                          });
                        },
                        decoration: InputDecoration(
                            labelText: 'Blood Group'
                        ),
                      )
                    ],
                  ),
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
                      child: Text("Request"),
                      onPressed: () async {
                        setState(() {
                          this.isLoading = true;
                        });
                        CollectionReference bloodDocumentRefrence =
                        FirebaseFirestore.instance
                            .collection('Blood_Donation');
                        await bloodDocumentRefrence.add({
                          "By_Name": name,
                          "Group": this.bloodGroup,
                          "Purpose": this.purpose,
                          "User": await this._firebaseMessaging.getToken(),
                          "Timestamp": DateTime.now(),
                          "done": false,
                          "Accepts": []
                        });
                        setState(() {
                          this.isLoading = false;
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
      appBar: generalAppBar(
          title: Text(
        "Blood Donations",
        style: TextStyle(color: Colors.black87),
      )),
      body: this.isLoading ? Center(child: CircularProgressIndicator(),) : SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                color: Colors.grey.shade400,
                child: Text(
                  this.isMine ? "All Requests" : "My Requests",
                  style: TextStyle(
                    color: Colors.grey.shade100
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    this.isMine = !this.isMine;
                  });
                  if (this.isMine) await this.loadFilteredDonationRequests();
                  else await this.loadDonationRequests();
                },
              ),
            ),
            SizedBox(height: 5,),
            Flexible(
              child: Column(
                children: this.getChildren(context),
              ),
            )
          ],
        )
      ),
    );
  }

  Future<void> loadFilteredDonationRequests() async {
    setState(() {
      this.isLoading = true;
      this._firebaseMessaging.getToken().then((value) => this.userToken = value);
    });

    Query bloodDonationCollectionReference =
    FirebaseFirestore.instance.collection('Blood_Donation').where("User", isEqualTo: this.userToken);

    bloodDonationCollectionReference.snapshots().listen((event) {
      setState(() {
        this.requests = event.docs;
        this.size = event.size;
        this.isLoading = false;
      });
    });
  }

  Future<void> loadDonationRequests() async {
    setState(() {
      this.isLoading = true;
      this._firebaseMessaging.getToken().then((value) => this.userToken = value);
    });

    CollectionReference bloodDonationCollectionReference =
        FirebaseFirestore.instance.collection('Blood_Donation');

    bloodDonationCollectionReference.snapshots().listen((event) {
      setState(() {
        this.requests = event.docs;
        this.size = event.size;
        this.isLoading = false;
      });
    });
  }

  List<Widget> getChildren(BuildContext context) {
    List<Widget> children = [];

    for (var index = 0; index < this.size; index++) {
      dynamic request = this.requests[index];
      children.add(Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30), color: Colors.white),
        child: InkWell(
          onTap: () async {
            Navigator.of(context).push(
                rightToLeft(BloodDonationDetailsUI(boodDonationId: request.id, userToken: this.userToken,))
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Hero(
                tag: request.id,
                child: CircleAvatar(
                  backgroundColor: request['done'] ? Colors.green : Colors.red,
                  radius: 25,
                  child: Text(
                    request["Group"],
                    style: TextStyle(
                        color: request['done']
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
                        request['By_Name'],
                        style: TextStyle(
                            color: Colors.blueGrey.shade600,
                            letterSpacing: 1,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat.yMMMd().add_jm().format(DateTime.parse(
                            request['Timestamp'].toDate().toString())),
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
                    request['Accepts'].length.toString() + " Response(s)",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    request["Purpose"],
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 10,),
                  FlatButton(
                    color: Colors.blue,
                    child: Text("Response", style: TextStyle(color: Colors.blue.shade100),),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              scrollable: true,
                              title: Text("Confirm"),
                              content: Column(
                                children: [
                                  Text("Response to this blood donation request?"),
                                  SizedBox(height: 20,),
                                  TextFormField(
                                    onChanged: (value) {
                                      setState(() {
                                        this.contactDetails = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        labelText: 'Contact Details'
                                    ),
                                  )
                                ],
                              ),
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
                                    setState(() {
                                      this.isLoading = true;
                                    });
                                    DocumentReference bloodDocumentRefrence =
                                    FirebaseFirestore.instance
                                        .collection('Blood_Donation')
                                        .doc(request.id);
                                    await bloodDocumentRefrence.update({
                                      "Accepts": FieldValue.arrayUnion([
                                        {
                                          "Contact_Details": this.contactDetails,
                                          "Group": request["Group"],
                                          "Name": name,
                                          "Timestamp": DateTime.now()
                                        }
                                      ])
                                    });
                                    Navigator.of(context).pop();
                                    await sendFCM(
                                      data: {"id": request.id},
                                        to: request["User"],
                                        title: "Blood Donation Response",
                                        body: name +
                                            " has responded to you blood donation request with contact details ${this.contactDetails}");
                                    setState(() {
                                      this.isLoading = false;
                                    });
                                  },
                                ),
                              ],
                            );
                          });
                    },
                  )
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
