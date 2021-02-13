import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medapp/sign_in.dart';

/// profile.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 14 Feb, 2021 3:12 AM

class ProfileUI extends StatefulWidget {
  @override
  _ProfileUIState createState() => _ProfileUIState();
}

class _ProfileUIState extends State<ProfileUI> {
  bool isLoading = false;
  QueryDocumentSnapshot user;
  bool isAdded = false;

  int height;

  String bloodGroup;

  int weight;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return this.isLoading != true
        ? this.isAdded
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
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(imageUrl),
                              radius: 50,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                    color: Colors.blueGrey.shade600,
                                    letterSpacing: 1,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Height",
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade300,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                          SizedBox(),
                                          Text(
                                            this.user['Height'].toString() +
                                                " cm",
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade900,
                                                fontWeight: FontWeight.w900,
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
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Weight",
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade300,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                          SizedBox(),
                                          Text(
                                            this.user['Weight'].toString() +
                                                " kg",
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade900,
                                                fontWeight: FontWeight.w900,
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
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Blood Group",
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade300,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13),
                                          ),
                                          SizedBox(),
                                          Text(
                                            this.user['Blood_Group'].toString(),
                                            style: TextStyle(
                                                color: Colors.blueGrey.shade900,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 13),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: Colors.blue,
                        onPressed: () async {
                          print(uid);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  scrollable: true,
                                  title: Text("User bio-data"),
                                  content: Column(
                                    children: [
                                      SizedBox(height: 20,),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        initialValue: this.user["Height"].toString(),
                                        onChanged: (value) {
                                          setState(() {
                                            this.height = int.parse(value);
                                          });
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Height in CM'
                                        ),
                                      ),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        initialValue: this.user["Weight"].toString(),
                                        onChanged: (value) {
                                          setState(() {
                                            this.weight = int.parse(value);
                                          });
                                        },
                                        decoration: InputDecoration(
                                            labelText: 'Weight in KG'
                                        ),
                                      ),
                                      TextFormField(
                                        initialValue: this.user["Blood_Group"],
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
                                      child: Text("Update"),
                                      onPressed: () async {
                                        setState(() {
                                          this.isLoading = true;
                                        });
                                        await this.editData(height: this.height, weight: this.weight, bloodGroup: this.bloodGroup);
                                        Navigator.of(context).pop();
                                        setState(() {
                                          this.isLoading = false;
                                        });
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Text(
                          "Edit your bio data",
                          style: TextStyle(
                              color: Colors.blue.shade100
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.all(20),
                child: FlatButton(
                  color: Colors.blue,
                  onPressed: () async {
                    print(uid);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            scrollable: true,
                            title: Text("User bio-data"),
                            content: Column(
                              children: [
                                SizedBox(height: 20,),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      this.height = int.parse(value);
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Height in CM'
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    setState(() {
                                      this.weight = int.parse(value);
                                    });
                                  },
                                  decoration: InputDecoration(
                                      labelText: 'Weight in KG'
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
                                child: Text("Add"),
                                onPressed: () async {
                                  setState(() {
                                    this.isLoading = true;
                                  });
                                  await this.addData(height: this.height, weight: this.weight, bloodGroup: this.bloodGroup);
                                  Navigator.of(context).pop();
                                  setState(() {
                                    this.isLoading = false;
                                  });
                                },
                              ),
                            ],
                          );
                        });
                  },
                  child: Text(
                    "Add bio data",
                    style: TextStyle(
                      color: Colors.blue.shade100
                    ),
                  ),
                ),
              )
        : Center(
            child: CircularProgressIndicator(),
          );
  }

  Future<void> loadData() async {
    setState(() {
      this.isLoading = true;
    });
    Query doctorsReference = FirebaseFirestore.instance
        .collection('User_Data')
        .where("User", isEqualTo: uid);

    doctorsReference.snapshots().listen((event) {
      setState(() {
        if (event.size == 0) {
          this.isAdded = false;
        } else {
          this.isAdded = true;
          this.user = event.docs[0];
        }
        this.isLoading = false;
      });
    });
  }
  
  Future<void> editData({int height, int weight, String bloodGroup}) async {
    DocumentReference userReference = FirebaseFirestore.instance
        .collection('User_Data')
        .doc(this.user.id);
    await userReference.update({
      "Blood_Group": bloodGroup,
      "Height": height,
      "Weight": weight
    });
  }

  Future<void> addData({int height, int weight, String bloodGroup}) async {
    CollectionReference userReference = FirebaseFirestore.instance
        .collection('User_Data');
    await userReference.add({
      "Blood_Group": bloodGroup,
      "Height": height,
      "Weight": weight,
      "User": uid
    });
  }
}
