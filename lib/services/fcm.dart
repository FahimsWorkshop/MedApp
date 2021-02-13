import 'dart:convert';

import 'package:http/http.dart' as http;


/// fcm.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 13 Feb, 2021 11:52 PM


Future<http.Response> sendFCM({String to, String title, String body, Map<String, dynamic> data}) {
  return http.post("https://fcm.googleapis.com/fcm/send", headers: {
    "Authorization": "key=AAAATncZIJ4:APA91bFN8bD00kamTpuYpF_vBD0-WBMJF30mMszzzXDxPDg9MK6CfFvSyhWd2os96dnaqm_MySSKHgEVp_6UBgpz9jh042SnPixff_SuwcbnZg_OLixfUTDd9kzbh4V2ClOFNcjrNkPD",
    "Accept": "application/json",
    "Content-Type": "application/json"
  }, body: jsonEncode({
    "to": to,
    "notification": {
      "title": title,
      "body": body
    },
    "data": data

  })).then((value) {
    print(value.body);
    return value;
  });
}
