import 'package:flutter/material.dart';

/// app_bar.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 13 Feb, 2021 10:50 PM


AppBar generalAppBar({Widget title}) => AppBar(
  iconTheme: IconThemeData(color: Colors.blueGrey),
  toolbarHeight: 80,
  backgroundColor: Color(0xfff1f1f1),
  elevation: 0,
  title: title,
  centerTitle: true,
);
