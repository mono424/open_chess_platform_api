library open_chess_platform_api;

import 'package:flutter/widgets.dart';

class ChessPlatformMeta {
  final String name;
  final String description;
  final ImageProvider logo;

  const ChessPlatformMeta(
      {required this.name, required this.description, required this.logo});
}
