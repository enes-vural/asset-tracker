// ignore_for_file: overridden_fields, annotate_overrides

import 'package:flutter/material.dart';

class CustomPadding extends Padding {
  final EdgeInsets padding;
  final Widget widget;

  const CustomPadding({super.key, required this.padding, required this.widget})
      : super(padding: padding, child: widget);

  static CustomPadding horizontal(
      {required Widget child, required double padding}) {
    return CustomPadding(
        padding: EdgeInsets.symmetric(horizontal: padding), widget: child);
  }

  static CustomPadding onlyTop(
      {required Widget child, required double padding}) {
    return CustomPadding(padding: EdgeInsets.only(top: padding), widget: child);
  }
}
