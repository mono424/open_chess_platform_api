import 'dart:async';

import 'package:chess_cloud_provider/models/chat_message.dart';
import 'package:chess_cloud_provider/models/chess_color.dart';
import 'package:chess_cloud_provider/models/game_status.dart';

class ChessGameState {
  final Stream<ChessGameState> _stream;

  // Game State
  GameStatus status = GameStatus.unknown;
  List<String> moves = [];
  Duration whiteTime = Duration.zero;
  Duration blackTime = Duration.zero;
  Duration whiteIncrement = Duration.zero;
  Duration blackIncrement = Duration.zero;
  bool clockRunning = false;
  DateTime timeBase = DateTime.now();
  ChessColor? winner = ChessColor.white;
  bool whiteOfferingDraw = false;
  bool blackOfferingDraw = false;
  bool whiteProposingTakeback = false;
  bool blackProposingTakeback = false;

  // Opponent Online State
  bool opponentOnline = true;
  DateTime claimWinAt = DateTime(0);

  // Chat
  List<ChatMessage> chat = [];

  ChessGameState(this._stream);

  Stream<ChessGameState> get stream {
    return _stream;
  }
}

class ChessGameStateController {
  final StreamController<ChessGameState> _streamController = StreamController();

  late final ChessGameState state =
      ChessGameState(_streamController.stream.asBroadcastStream());

  ChessGameStateController();

  void updateState({
    required GameStatus status,
    required List<String> moves,
    required Duration whiteTime,
    required Duration blackTime,
    required Duration whiteIncrement,
    required Duration blackIncrement,
    required bool clockRunning,
    required bool whiteOfferingDraw,
    required bool blackOfferingDraw,
    required bool whiteProposingTakeback,
    required bool blackProposingTakeback,
    ChessColor? winner,
    DateTime? timeBase }) {
    state.status = status;
    state.moves = moves;
    state.whiteTime = whiteTime;
    state.blackTime = blackTime;
    state.whiteIncrement = whiteIncrement;
    state.blackIncrement = blackIncrement;
    state.clockRunning = clockRunning;
    state.whiteOfferingDraw = whiteOfferingDraw;
    state.blackOfferingDraw = blackOfferingDraw;
    state.whiteProposingTakeback = whiteProposingTakeback;
    state.blackProposingTakeback = blackProposingTakeback;
    state.winner = winner;
    state.timeBase = timeBase ?? DateTime.now();
    _notify();
  }

  void updateOpponentOnline(bool online, {DateTime? claimWinAt}) {
    state.opponentOnline = online;
    state.claimWinAt = claimWinAt ?? DateTime(0);
    _notify();
  }

  void addChatMessage({ required String username, required String content, DateTime? createdAt }) {
    state.chat.add(ChatMessage(username: username, content: content, createdAt: createdAt ?? DateTime.now()));
    _notify();
  }

  void _notify() {
    _streamController.add(state);
  }
}
