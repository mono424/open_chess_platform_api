library chess_cloud_provider;

class LichessOptions {
  String token;
  String lichessUrl; // https://xyz.com/api/lichess/refresh-token
  String tokenRefreshUrl; // https://xyz.com/api/lichess/refresh-token
  Duration connectionTimeout;

  LichessOptions({required this.token, required this.tokenRefreshUrl, this.lichessUrl = 'https://lichess.org', this.connectionTimeout = const Duration(seconds: 10)});
}