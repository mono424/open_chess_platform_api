library chess_cloud_provider;

import 'dart:io';

import 'package:chess_cloud_provider/chess_platform_exception.dart';

class ChessPlatformHttpException extends ChessPlatformException {
  final HttpClientResponse response;
  final String message;
  ChessPlatformHttpException(this.response, this.message);
}

class ChessPlatformNotAuthorizedException extends ChessPlatformHttpException {
  ChessPlatformNotAuthorizedException(
      HttpClientResponse response, String message)
      : super(response, message);
}
