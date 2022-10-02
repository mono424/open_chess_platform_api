abstract class ChessPlatformCredentials {}

class ChessPlatformCredentialsToken extends ChessPlatformCredentials {
  final String token;

  ChessPlatformCredentialsToken(this.token);
}

class ChessPlatformCredentialsPassword extends ChessPlatformCredentials {
  final String username;
  final String password;

  ChessPlatformCredentialsPassword(this.username, this.password);
}
