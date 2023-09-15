library open_chess_platform_api;

import 'dart:io';

class LichessOptions {

  /// The URL of the Lichess API.
  String lichessUrl;

  /// The URL of the token refresh endpoint.
  String tokenRefreshUrl;

  /// The user agent to use for HTTP requests.
  String? userAgent;

  /// The timeout for HTTP requests.
  Duration connectionTimeout;

  /// The idle timeout for HTTP requests.
  Duration idleTimeout;

  /// The HTTP client to use for HTTP requests.
  HttpClient? httpClient;

  /// The default delay between retries.
  Duration defaultRetryDelay;

  /// The default number of retries.
  int defaultRetries;
  
  /// The default time after which a stream is considered inactive and will be reconnected.
  Duration streamReconnectInactivityTime;

  LichessOptions({
    required this.tokenRefreshUrl,
    this.lichessUrl = 'https://lichess.org',
    this.userAgent,
    this.connectionTimeout = const Duration(seconds: 10),
    this.idleTimeout = const Duration(hours: 12),
    this.httpClient,
    this.defaultRetryDelay = const Duration(milliseconds: 200),
    this.defaultRetries = 3,
    this.streamReconnectInactivityTime = const Duration(seconds: 30),
  });
}
