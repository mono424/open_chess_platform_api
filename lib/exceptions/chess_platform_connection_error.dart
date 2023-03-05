library chess_cloud_provider;

import 'package:chess_cloud_provider/chess_platform_exception.dart';

class ChessPlatformConnectionError extends ChessPlatformException {
  final dynamic raw;

  ChessPlatformConnectionError(this.raw);
}
