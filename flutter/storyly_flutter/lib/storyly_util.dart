
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';



extension StorylyHexColor on Color {
  String toHexString() {
    return '#${value.toRadixString(16).padLeft(8, '0')}';
  }
}

T? castOrNull<T>(x) => x is T ? x : null;