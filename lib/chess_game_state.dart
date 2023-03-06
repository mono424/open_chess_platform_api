import 'dart:async';

import 'package:chess_cloud_provider/chess_platform_exception.dart';
import 'package:chess_cloud_provider/models/chat_message.dart';
import 'package:chess_cloud_provider/models/chess_color.dart';
import 'package:chess_cloud_provider/models/chess_game_connection_state.dart';
import 'package:chess_cloud_provider/models/game_status.dart';

class ChessGameStateIntGetter {
  ChessGameStateInt Function()? get;
}

class ChessGameStateInt {
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

  // Connection State
  ChessGameConnectionState connectionState = ChessGameConnectionState.disconnected;
  ChessPlatformException? connectionError;
}

class ChessGameState {
  final Stream<ChessGameState> _stream;
  final ChessGameStateInt _state = ChessGameStateInt();

  // Getters
  GameStatus get status => _state.status;
  List<String> get moves => [..._state.moves];
  Duration get whiteTime => _state.whiteTime;
  Duration get blackTime => _state.blackTime;
  Duration get whiteIncrement => _state.whiteIncrement;
  Duration get blackIncrement => _state.blackIncrement;
  bool get clockRunning => _state.clockRunning;
  DateTime get timeBase => _state.timeBase;
  ChessColor? get winner => _state.winner;
  bool get whiteOfferingDraw => _state.whiteOfferingDraw;
  bool get blackOfferingDraw => _state.blackOfferingDraw;
  bool get whiteProposingTakeback => _state.whiteProposingTakeback;
  bool get blackProposingTakeback => _state.blackProposingTakeback;
  bool get opponentOnline => _state.opponentOnline;
  DateTime get claimWinAt => _state.claimWinAt;
  List<ChatMessage> get chat => [..._state.chat];
  ChessGameConnectionState get connectionState => _state.connectionState;
  ChessPlatformException? get connectionError => _state.connectionError;

  ChessGameState(this._stream, getter) {
    getter.get = () => _state;
  }

  Stream<ChessGameState> get stream {
    return _stream;
  }

  // Convinience Methods
  Duration whiteTimeLeft(bool isRunning) => isRunning ? (whiteTime - (DateTime.now().difference(timeBase))) : whiteTime;
  Duration blackTimeLeft(bool isRunning) => isRunning ? (blackTime - (DateTime.now().difference(timeBase))) : blackTime;
}

class ChessGameStateController {
  final StreamController<ChessGameState> _streamController = StreamController();
  final ChessGameStateIntGetter _stateGetter = ChessGameStateIntGetter();
  late final ChessGameState _state = ChessGameState(_streamController.stream.asBroadcastStream(), _stateGetter);

  ChessGameState get state => _state;

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
    DateTime? timeBase,
  }) {
    final state = _stateGetter.get!();
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
    final state = _stateGetter.get!();
    state.opponentOnline = online;
    state.claimWinAt = claimWinAt ?? DateTime(0);
    _notify();
  }

  void setConnectionState(ChessGameConnectionState connectionState, { ChessPlatformException? connectionError }) {
    final state = _stateGetter.get!();
    state.connectionState = connectionState;
    state.connectionError = connectionError;
    _notify();
  }

  void addChatMessage({ required String username, required String content, DateTime? createdAt }) {
    final state = _stateGetter.get!();
    state.chat.add(ChatMessage(username: username, content: content, createdAt: createdAt ?? DateTime.now()));
    _notify();
  }

  void _notify() {
    _streamController.add(_state);
  }
}
