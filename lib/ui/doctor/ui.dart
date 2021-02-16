import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zoton/sign_in.dart';
import 'package:zoton/ui/animations/route.dart';
import 'package:zoton/ui/blood_donation/ui.dart';
import 'package:zoton/ui/home/ui.dart';
import 'package:zoton/utils/uiHelpers.dart';
import 'package:readmore/readmore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// ui.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 09 Feb, 2021 6:27 AM

class DoctorUI extends StatefulWidget {
  final doctorID;
  final bool isScheduled;
  final appointmentID;

  DoctorUI({@required this.doctorID, this.isScheduled, this.appointmentID});

  @override
  _DoctorUIState createState() => _DoctorUIState();
}

class _DoctorUIState extends State<DoctorUI> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool isLoading = false;
  Map<String, dynamic> doctor;

  @override
  void initState() {
    loadData();
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
                            .push(rightToLeft(BloodDonationUI()));
                      }),
                ],
              ));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.blueGrey),
        toolbarHeight: 80,
        backgroundColor: Color(0xfff1f1f1),
        elevation: 0,
      ),
      body: this.isLoading != true
          ? SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 60,
                        child: Hero(
                            tag: this.widget.doctorID,
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(this.doctor['PhotoURL']),
                              radius: 50,
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor['Name'],
                                  style: TextStyle(
                                      color: Colors.blueGrey.shade600,
                                      letterSpacing: 1,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  doctor['Field'],
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  doctor['Certificates'],
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  doctor['Treatments'],
                                  style: TextStyle(
                                      color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 5,),
                                Text(
                                  doctor['Chamber'],
                                  style: TextStyle(
                                      color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  doctor['Visiting_Hour'],
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  doctor['Practice_Days'],
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                            constraints: BoxConstraints(
                              maxWidth: 180
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          doctor['Reviews'].length != 0 &&
                                  doctor['Rating'] != 0
                              ? Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          child: Icon(
                                            Icons.star_rate_rounded,
                                            size: 35,
                                            color: Colors
                                                .orangeAccent.shade200,
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Rating",
                                              style: TextStyle(
                                                  color: Colors
                                                      .blueGrey.shade300,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  fontSize: 13),
                                            ),
                                            SizedBox(),
                                            Text(
                                              this
                                                      .doctor['Rating']
                                                      .toString() +
                                                  " out of 5",
                                              style: TextStyle(
                                                  color: Colors
                                                      .blueGrey.shade900,
                                                  fontWeight:
                                                      FontWeight.w900,
                                                  fontSize: 13),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        CircleAvatar(
                                          child: Icon(
                                            Icons.group_rounded,
                                            size: 25,
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Patients",
                                              style: TextStyle(
                                                  color: Colors
                                                      .blueGrey.shade300,
                                                  fontWeight:
                                                      FontWeight.bold,
                                                  fontSize: 13),
                                            ),
                                            SizedBox(),
                                            Text(
                                              this
                                                      .doctor[
                                                          'PatientsNumber']
                                                      .toString() +
                                                  "+",
                                              style: TextStyle(
                                                  color: Colors
                                                      .blueGrey.shade900,
                                                  fontWeight:
                                                      FontWeight.w900,
                                                  fontSize: 13),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              : Text(
                                  "No reviews yet",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.black26,
                                      fontWeight: FontWeight.bold),
                                )
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                    ),
                    color: this.widget.isScheduled ? Colors.red.shade800 : Colors.blue.shade800,
                    onPressed: this.widget.isScheduled ? cancelAppointment : setAppointment,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: this.widget.isScheduled ? Text("Cancel Appointment", style: TextStyle(color: Colors.red.shade100, fontWeight: FontWeight.w900),)
                      : Text("Get Appointment", style: TextStyle(color: Colors.blue.shade100, fontWeight: FontWeight.w900),),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  margin:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Biography",
                        style: TextStyle(
                            color: Colors.blueGrey.shade600,
                            letterSpacing: 1,
                            fontSize: 18,
                            fontWeight: FontWeight.w900),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ReadMoreText(
                        this.doctor['Biography'],
                        trimLines: 5,
                        colorClickableText: Colors.blue.shade700,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: 'Show more',
                        trimExpandedText: 'Show less',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Reviews (${this.doctor['Reviews'].toList().length})",
                            style: TextStyle(
                                color: Colors.blueGrey.shade600,
                                letterSpacing: 1,
                                fontSize: 18,
                                fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: this.doctor['Reviews'].toList().length != 0 ? this.getReviews() : [],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future<void> loadData() async {
    setState(() {
      this.isLoading = true;
    });
    CollectionReference doctorsReference =
        FirebaseFirestore.instance.collection('Doctors');

    doctorsReference.doc(this.widget.doctorID).snapshots().listen((event) {
      setState(() {
        this.doctor = event.data();
        print(this.doctor);
        this.isLoading = false;
      });
    });
  }

  List<Widget> getReviews() {
    List<Widget> reviews = [];
    for (var i = 0; i < List.from(this.doctor['Reviews']).length; i++) {
      var review = List.from(this.doctor['Reviews'])[i];
      reviews.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            review['Name'],
            style: TextStyle(
                color: Colors.blueGrey.shade600,
                letterSpacing: 1,
                fontSize: 14,
                fontWeight: FontWeight.w900),
          ),
          getRateIcons(review["Rating"]),
          SizedBox(
            height: 5,
          ),
          ReadMoreText(review['Comment'],
              trimLines: 3,
              colorClickableText: Colors.blue.shade700,
              trimMode: TrimMode.Line,
              trimCollapsedText: 'Show more',
              trimExpandedText: 'Show less',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              )),
          SizedBox(
            height: 7,
          ),
        ],
      ));

    }
    return reviews;
  }

  Future<void> setAppointment() async {
    this.isLoading = true;
    CollectionReference doctorCollection = FirebaseFirestore.instance.collection("Appointments");
    await doctorCollection.add({
      "Doctor": this.widget.doctorID,
      "DoctorField": this.doctor["Field"],
      "DoctorName": this.doctor["Name"],
      "DoctorPhotoUrl": this.doctor["PhotoURL"],
      "Timestamp": DateTime.now().add(Duration(days: 1)),
      "User": uid
    });
    this.isLoading = false;
    Navigator.of(context).pushAndRemoveUntil(
      rightToLeft(UI()),
      (Route<dynamic> route) => false
    );
  }

  Future<void> cancelAppointment() async {
    this.isLoading = true;
    CollectionReference doctorCollection = FirebaseFirestore.instance.collection("Appointments");
    await doctorCollection.doc(this.widget.appointmentID).delete();
    this.isLoading = false;
    Navigator.of(context).pushAndRemoveUntil(
        rightToLeft(UI()),
            (Route<dynamic> route) => false
    );
  }
}
