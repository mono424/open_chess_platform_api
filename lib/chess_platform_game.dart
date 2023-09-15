library open_chess_platform_api;

import 'package:open_chess_platform_api/chess_game_state.dart';
import 'package:open_chess_platform_api/models/chess_color.dart';
import 'package:open_chess_platform_api/models/game_time_type.dart';

abstract class ChessPlatformGame {
  
  /// The id of the game
  String get id;

  /// The color of the player
  ChessColor get color;

  /// The type of game
  GameTimeType get gameTimeType;

  /// The id of the opponent
  dynamic get opponentId;

  /// The name of the opponent
  String get opponentName;

  /// The rating of the opponent for the game type
  int get opponentRating;

  /// The current state of the game
  ChessGameState getState();

  /// Reconnect to the game
  Future<void> reconnect();

  /// Make a move
  Future<void> move(String move);

  /// Accept a draw offer
  Future<void> acceptDraw();

  /// Decline a draw offer
  Future<void> declineDraw();

  /// Offer a draw
  Future<void> offerDraw();

  /// Resign the game
  Future<void> resign();

  /// Send a chat message
  Future<void> sendMessage(String message);

  /// Dispose close all connections
  void dispose();

}
