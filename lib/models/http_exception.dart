library chess_cloud_provider;

import 'dart:io';

import 'package:chess_cloud_provider/chess_provider_exception.dart';

class ChessProviderHttpException extends ChessProviderException {
  final HttpClientResponse response;
  final String message;
  ChessProviderHttpException(this.response, this.message);
}