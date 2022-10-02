library open_chess_platform_api;

import 'package:async/async.dart';
import 'package:open_chess_platform_api/chess_platform_credentials.dart';
import 'package:open_chess_platform_api/chess_platform_user.dart';
import 'package:open_chess_platform_api/models/challenge_result.dart';
import 'package:open_chess_platform_api/models/chess_color_selection.dart';
import 'package:open_chess_platform_api/models/game.dart';
import 'package:open_chess_platform_api/models/platform_event.dart';
import 'package:open_chess_platform_api/chess_platform_meta.dart';
import 'package:open_chess_platform_api/models/time_option.dart';

abstract class ChessPlatform {
  /// Stores general information about the platform.
  final ChessPlatformMeta meta;

  /// Initializes a new ChessPlatform with specified [meta] data.
  ChessPlatform(this.meta);

  Future<Stream<PlatformEvent>> listenForEvents();

  /// Returns wether the user is currently authenticated or not.
  bool hasAuth();

  Future<void> authenticate(ChessPlatformCredentials credentials);

  // Gets friend list filtered by the query.
  Future<List<ChessPlatformUser>> getFriend(String query);

  // Challenge an other user.
  Future<ChallengeResult> createChallenge(
    String username, {
    bool rated = false,
    TimeOption time,
    ChessColorSelection color = ChessColorSelection.random,
  });

  // Seeks a random oppoent and starts a new game
  Future<CancelableOperation<GameResult>> seekGame({
    bool rated = false,
    required TimeOption time,
    ChessColorSelection color = ChessColorSelection.random,
  });
}
