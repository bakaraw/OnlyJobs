import 'package:flutter/material.dart';

// Colors
const Color backgroundwhite = Color(0xFFFFFFFF);
const Color backgroundblack = Color(0xFF000000);

const Color primarycolor = Color(0xFF3E595C);
const Color secondarycolor = Color(0xFFDAF0F2);

const Color accent1 = Color(0xFFFE6A1E);
const Color accent2 = Color(0xFFB1EF6B);

/// TextStyle Constants
const TextStyle headingStyle = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
);

const TextStyle headingStyle_white = TextStyle(
  fontSize: 24.0,
  fontWeight: FontWeight.bold,
  color: backgroundwhite,
);

const TextStyle bodyStyle = TextStyle(
  fontSize: 16.0,
  color: Color.fromARGB(255, 99, 99, 99),
);

const TextStyle errortxtstyle = TextStyle(
  fontWeight: FontWeight.bold,
  color: Colors.red,
  letterSpacing: 1,
  fontSize: 18,
);

const TextStyle addinfotxtstyle = TextStyle(
  fontWeight: FontWeight.w500,
  color: Colors.blue,
  fontSize: 16,
);

const InputDecoration textFieldStyleSM = InputDecoration(
  border: OutlineInputBorder(),
  hintText: 'Enter Email Address',
  contentPadding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 3), // Adjust the vertical padding as needed
);

/// Size Constants (Padding and Margins)
const double smallPadding = 8.0;
const double mediumPadding = 16.0;
const double largePadding = 24.0;

// SizedBox Constants for Vertical Spacing
const SizedBox extraSmallSizedBox_H = SizedBox(height: 4.0);
const SizedBox smallSizedBox_H = SizedBox(height: 8.0);
const SizedBox mediumSizedBox_H = SizedBox(height: 16.0);
const SizedBox largeSizedBox_H = SizedBox(height: 24.0);
const SizedBox extraLargeSizedBox_H = SizedBox(height: 32.0);

// SizedBox Constants for Horizontal Spacing
const SizedBox extraSmallSizedBox_W =
    SizedBox(width: 4.0); // Extra small horizontal spacing
const SizedBox smallSizedBox_W = SizedBox(width: 8.0);
const SizedBox mediumSizedBox_W = SizedBox(width: 16.0);
const SizedBox largeSizedBox_W = SizedBox(width: 24.0);
const SizedBox extraLargeSizedBox_W = SizedBox(width: 32.0);
