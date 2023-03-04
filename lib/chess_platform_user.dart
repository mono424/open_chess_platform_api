import 'package:chess_cloud_provider/models/game_time_type.dart';
import 'package:flutter/material.dart';

abstract class ChessPlatformUser {
  String get id;
  String get displayName;
  String get biography;
  ImageProvider get imageSrc;

  int getRating(GameTimeType type);

  ChessPlatformUser();
}
