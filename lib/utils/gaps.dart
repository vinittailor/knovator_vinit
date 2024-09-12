import 'package:flutter/material.dart';

// Extension method for the int type named Gaps
extension Gaps on int {

  // This method returns a SizedBox widget with a specified height
  // based on the value of the calling integer (converted to double)
  SizedBox get hGap => SizedBox(height: (this).toDouble(),);

  // This method returns a SizedBox widget with a specified width
  // based on the value of the calling integer (converted to double)
  SizedBox get wGap => SizedBox(width: (this).toDouble(),);
}