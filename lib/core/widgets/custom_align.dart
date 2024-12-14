// ignore_for_file: annotate_overrides, overridden_fields

import 'package:flutter/material.dart';

class CustomAlign extends Align {
  ///default constracture
  const CustomAlign({super.key, required super.child, required super.alignment})
      : super();

  ///preset top center align constructure
  const CustomAlign.topCenter({super.key, required Widget child})
      : super(child: child, alignment: Alignment.topCenter);

  const CustomAlign.topLeft({super.key, required Widget child})
      : super(child: child, alignment: Alignment.topLeft);

  const CustomAlign.topRight({super.key, required Widget child})
      : super(child: child, alignment: Alignment.topRight);

  const CustomAlign.center({super.key, required Widget child})
      : super(child: child, alignment: Alignment.center);

  const CustomAlign.centerLeft({super.key, required Widget child})
      : super(child: child, alignment: Alignment.centerLeft);

  const CustomAlign.centerRight({super.key, required Widget child})
      : super(child: child, alignment: Alignment.centerRight);

  const CustomAlign.bottomCenter({super.key, required Widget child})
      : super(child: child, alignment: Alignment.bottomCenter);

  const CustomAlign.bottomRight({super.key, required Widget child})
      : super(child: child, alignment: Alignment.bottomRight);

  const CustomAlign.bottomLeft({super.key, required Widget child})
      : super(child: child, alignment: Alignment.bottomLeft);
}
