library chess_cloud_provider;

import 'dart:ffi';
import 'dart:io';

class LichessOptions {
  String lichessUrl; // https://xyz.com/api/lichess/refresh-token
  String tokenRefreshUrl; // https://xyz.com/api/lichess/refresh-token
  String? userAgent;
  Duration connectionTimeout;
  Duration idleTimeout;
  HttpClient? httpClient;
  Duration defaultRetryDelay;
  int defaultRetries;

  LichessOptions({
    required this.tokenRefreshUrl,
    this.lichessUrl = 'https://lichess.org',
    this.userAgent,
    this.connectionTimeout = const Duration(seconds: 10),
    this.idleTimeout = const Duration(hours: 12),
    this.httpClient,
    this.defaultRetryDelay = const Duration(milliseconds: 200),
    this.defaultRetries = 3,
  });
}
