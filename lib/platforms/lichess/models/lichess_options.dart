library chess_cloud_provider;

class LichessOptions {
  String lichessUrl; // https://xyz.com/api/lichess/refresh-token
  String tokenRefreshUrl; // https://xyz.com/api/lichess/refresh-token
  String? userAgent;
  Duration connectionTimeout;
  Duration idleTimeout;

  LichessOptions(
      {required this.tokenRefreshUrl,
      this.lichessUrl = 'https://lichess.org',
      this.userAgent,
      this.connectionTimeout = const Duration(seconds: 10),
      this.idleTimeout = const Duration(hours: 12)});
}
