import 'package:async/async.dart';
import 'package:open_chess_platform_api/chess_platform_game.dart';

class ChallengeRequest {
  final CancelableOperation<ChessPlatformGame> operation;
  final dynamic meta;

  ChallengeRequest(this.operation, this.meta);
}
