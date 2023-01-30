library open_chess_platform_api;

class LichessOptions {
  String lichessUrl; // https://xyz.com/api/lichess/refresh-token
  String tokenRefreshUrl; // https://xyz.com/api/lichess/refresh-token
  Duration connectionTimeout;
  Duration idleTimeout;

  LichessOptions(
      {required this.tokenRefreshUrl,
      this.lichessUrl = 'https://lichess.org',
      this.connectionTimeout = const Duration(seconds: 10),
      this.idleTimeout = const Duration(hours: 12)});
}
