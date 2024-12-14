// ignore_for_file: annotate_overrides, overridden_fields

import 'package:flutter/material.dart';

class CustomAlign extends Align {
  ///default constracture
  const CustomAlign({super.key, required super.child, required super.alignment})
      : super();

  ///preset top center align constructure
  const CustomAlign.topCenter({super.key, required Widget widget})
      : super(child: widget, alignment: Alignment.topCenter);

  ///preset center right align constructure
  const CustomAlign.centerRight({super.key, required Widget widget})
      : super(child: widget, alignment: Alignment.centerRight);
  ///preset center right align constructure
  const CustomAlign.center({super.key, required Widget widget})
      : super(child: widget, alignment: Alignment.center);
}
