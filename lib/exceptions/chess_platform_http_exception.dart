library open_chess_platform_api;

import 'dart:io';

import 'package:open_chess_platform_api/chess_platform_exception.dart';

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
