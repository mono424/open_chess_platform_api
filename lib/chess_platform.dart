library chess_cloud_provider;

import 'package:async/async.dart';
import 'package:chess_cloud_provider/chess_platform_credentials.dart';
import 'package:chess_cloud_provider/chess_platform_game.dart';
import 'package:chess_cloud_provider/chess_platform_state.dart';
import 'package:chess_cloud_provider/chess_platform_user.dart';
import 'package:chess_cloud_provider/models/challenge_request.dart';
import 'package:chess_cloud_provider/models/chess_color.dart';
import 'package:chess_cloud_provider/models/chess_rating_range.dart';
import 'package:chess_cloud_provider/models/platform_event.dart';
import 'package:chess_cloud_provider/chess_platform_meta.dart';
import 'package:chess_cloud_provider/models/time_option.dart';
import 'package:chess_cloud_provider/chess_platform_logger.dart';

abstract class ChessPlatform {
  /// Stores general information about the platform.
  final ChessPlatformMeta meta;
  final ChessPlatformLogger logger;

  /// Initializes a new ChessPlatform with specified [meta] data.
  ChessPlatform(this.meta, { this.logger = const DummyLogger() });

  /// Returns an auto managed state
  ChessPlatformState getState();

  /// Event Stream for platform related events.
  Future<Stream<PlatformEvent>> listenForEvents();

  /// Returns wether the user is currently authenticated or not.
  bool hasAuth();

  /// Authenticate a user with his credentials.
  Future<void> authenticate(ChessPlatformCredentials credentials);

  /// Deauthenticate the current user.
  Future<void> deauthenticate();

  // Gets friend list filtered by the query.
  Future<List<ChessPlatformUser>> getFriend(String query);

  // Challenge an other user.
  Future<ChallengeRequest> createChallenge(
    String userId, {
    bool rated = false,
    required TimeOption time,
    ChessColor color = ChessColor.random,
  });

  // Seeks a random oppoent and starts a new game
  Future<CancelableOperation<ChessPlatformGame>> seekGame({
    bool rated = false,
    required TimeOption time,
    ChessColor color = ChessColor.random,
    ChessRatingRange? ratingRange,
  });
}
