import 'package:open_chess_platform_api/models/game_time_type.dart';
import 'package:flutter/material.dart';

abstract class ChessPlatformUser {
  String get id;
  String get displayName;
  String get biography;
  ImageProvider get imageSrc;

  int getRating(GameTimeType type);

  ChessPlatformUser();
}
