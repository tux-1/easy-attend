import 'package:flutter/material.dart';

extension FlutterUtils on num {
  // Core spacing utilities
  SizedBox get h => SizedBox(height: toDouble());
  SizedBox get w => SizedBox(width: toDouble());

  // Padding utilities
  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());
  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: toDouble());
  EdgeInsets get paddingHorizontal => EdgeInsets.symmetric(horizontal: toDouble());
  EdgeInsets get paddingLeft => EdgeInsets.only(left: toDouble());
  EdgeInsets get paddingTop => EdgeInsets.only(top: toDouble());
  EdgeInsets get paddingRight => EdgeInsets.only(right: toDouble());
  EdgeInsets get paddingBottom => EdgeInsets.only(bottom: toDouble());

  // Border radius utilities
  BorderRadius get borderRadiusCircular => BorderRadius.circular(toDouble());
  BorderRadius get borderRadiusTop => BorderRadius.vertical(top: Radius.circular(toDouble()));
  BorderRadius get borderRadiusBottom => BorderRadius.vertical(bottom: Radius.circular(toDouble()));

  // Responsive design utilities
  double responsiveWidth(BuildContext context) => toDouble() * MediaQuery.sizeOf(context).width;
  double responsiveHeight(BuildContext context) => toDouble() * MediaQuery.sizeOf(context).height;

  // Duration utilities
  Duration get milliseconds => Duration(milliseconds: toInt());
  Duration get seconds => Duration(seconds: toInt());
  Duration get minutes => Duration(minutes: toInt());
  Duration get hours => Duration(hours: toInt());

  // Layout constraints
  BoxConstraints get maxWidthConstraint => BoxConstraints(maxWidth: toDouble());
  BoxConstraints get maxHeightConstraint => BoxConstraints(maxHeight: toDouble());
  BoxConstraints get minWidthConstraint => BoxConstraints(minWidth: toDouble());
  BoxConstraints get minHeightConstraint => BoxConstraints(minHeight: toDouble());

  // Transformation matrices
  Matrix4 get translateX => Matrix4.translationValues(toDouble(), 0, 0);
  Matrix4 get translateY => Matrix4.translationValues(0, toDouble(), 0);
  Matrix4 get scaleUniform => Matrix4.diagonal3Values(toDouble(), toDouble(), 1);

}