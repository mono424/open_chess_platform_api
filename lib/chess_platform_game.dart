library chess_cloud_provider;

import 'package:chess_cloud_provider/chess_game_state.dart';
import 'package:chess_cloud_provider/models/chess_color.dart';
import 'package:chess_cloud_provider/models/game_time_type.dart';

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

}
