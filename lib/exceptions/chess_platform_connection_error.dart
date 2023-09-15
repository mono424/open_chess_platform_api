library open_chess_platform_api;

import 'package:open_chess_platform_api/chess_platform_exception.dart';

class ChessPlatformConnectionError extends ChessPlatformException {
  final dynamic raw;

  ChessPlatformConnectionError(this.raw);
}
