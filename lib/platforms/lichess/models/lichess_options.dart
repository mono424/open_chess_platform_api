library chess_cloud_provider;

import 'dart:io';

class LichessOptions {
  String lichessUrl; // https://xyz.com/api/lichess/refresh-token
  String tokenRefreshUrl; // https://xyz.com/api/lichess/refresh-token
  String? userAgent;
  Duration connectionTimeout;
  Duration idleTimeout;
  HttpClient? httpClient;

  LichessOptions(
      {required this.tokenRefreshUrl,
      this.lichessUrl = 'https://lichess.org',
      this.userAgent,
      this.connectionTimeout = const Duration(seconds: 10),
      this.idleTimeout = const Duration(hours: 12),
      this.httpClient});
}
