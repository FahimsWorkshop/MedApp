import 'package:flutter/material.dart';

/// uiHelpers.dart
///
/// Copyright 2021 The Medapp Developers. All rights reserved.
/// Use of this source code is governed by a Commercial license that can be.
/// found in the LICENSE file.
///
/// Created by
/// Fahim Al Islam 09 Feb, 2021 3:38 AM



Widget getRateIcons(int meanPoints, {
  Color fillColor,
  Color blankColor,
  EdgeInsets padding,
  double spaceBetween,
  Icon fillIcon,
  Icon blankIcon,
  double size}) {
  if (size == null) size = 12.0;
  if (fillColor == null) fillColor = Colors.indigo;
  if (blankColor == null) blankColor = Colors.indigo.shade100;
  if (padding == null) padding = EdgeInsets.all(2);
  if (spaceBetween == null) spaceBetween = 2.00;
  if (fillIcon == null) fillIcon = Icon(Icons.star_rounded, color: fillColor, size: size,);
  if (blankIcon == null) blankIcon = Icon(Icons.star_rounded, color: blankColor, size: size,);

  assert(meanPoints <= 5);

  if (meanPoints == 0) return Text("No reviews yet", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),);

  int rest = 5 - meanPoints;

  List<Widget> icons = [];

  for (var i = 1; i <= meanPoints; i++) {
    icons.add(fillIcon);
    if (i != meanPoints) icons.add(SizedBox(width: spaceBetween,));
  }

  if (rest != 0) icons.add(SizedBox(width: spaceBetween,));

  for (var i = 1; i <= rest; i++) {
    icons.add(blankIcon);
    if (i != rest) icons.add(SizedBox(width: spaceBetween,));
  }

  return Padding(
    padding: padding,
    child: Row(
      children: icons,
    ),
  );
}
