import 'package:flutter/material.dart';

abstract class ChessPlatformUser {
  String get id;
  String get displayName;
  String get biography;
  ImageProvider get imageSrc;

  ChessPlatformUser();
}
