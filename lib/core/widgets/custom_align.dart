// ignore_for_file: annotate_overrides, overridden_fields

import 'package:flutter/material.dart';

class CustomAlign extends Align {
  final Widget widget;
  final Alignment alignment;

  const CustomAlign({super.key, required this.widget, required this.alignment})
      : super(child: widget, alignment: alignment);
  //super gerekliligi tartisilir mi

  factory CustomAlign.topCenter({required Widget child}) =>
      CustomAlign(widget: child, alignment: Alignment.topCenter);

  factory CustomAlign.centerRight({required Widget child}) =>
      CustomAlign(widget: child, alignment: Alignment.centerRight);
}
