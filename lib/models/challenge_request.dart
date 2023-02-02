import 'package:async/async.dart';
import 'package:chess_cloud_provider/chess_platform_game.dart';

class ChallengeRequest {
  final CancelableOperation<ChessPlatformGame> operation;
  final dynamic meta;

  ChallengeRequest(this.operation, this.meta);
}
