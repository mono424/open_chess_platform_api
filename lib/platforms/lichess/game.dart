import 'dart:async';

import 'package:chess_cloud_provider/chess_game_state.dart';
import 'package:chess_cloud_provider/chess_platform_game.dart';
import 'package:chess_cloud_provider/exceptions/chess_platform_connection_error.dart';
import 'package:chess_cloud_provider/exceptions/chess_platform_illegal_game_action.dart';
import 'package:chess_cloud_provider/models/chess_game_connection_state.dart';
import 'package:chess_cloud_provider/platforms/lichess/lichess.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/game-events/lichess_game_event_opponent_gone.dart';
import 'package:chess_cloud_provider/platforms/lichess/utils.dart';

class LichessGame extends ChessPlatformGame {
  final Lichess lichess;
  late final LichessGameInfo info;

  late final ChessGameStateController _stateController = ChessGameStateController();
  
  StreamSubscription<LichessGameEvent>? gameStreamSub;

  late final void Function() _triggerInactivitiyReconnct;

  LichessGame({required this.info, required this.lichess}) {
    _triggerInactivitiyReconnct = debounce(() => reconnect(), duration: lichess.options.streamReconnectInactivityTime);
    _connect();
  }

  @override
  String get id => info.gameId;

  @override
  GameTimeType get gameTimeType => parseSpeed(info.perf);

  @override
  ChessColor get color => info.color == "white" ? ChessColor.white : ChessColor.black;

  @override
  String get opponentId => info.opponent.id;

  @override
  String get opponentName => info.opponent.username;

  @override
  int get opponentRating => info.opponent.rating;

  @override
  ChessGameState getState() {
    return _stateController.state;
  }

  @override
  Future<void> acceptDraw() async {
    if (!(await lichess.handleDrawOffer(id, true))) {
      throw ChessPlatformIllegalGameAction();
    }
  }
  
  @override
  Future<void> declineDraw() async {
    if (!(await lichess.handleDrawOffer(id, false))) {
      throw ChessPlatformIllegalGameAction();
    }
  }
  
  @override
  Future<void> move(String move) async {
    if (!(await lichess.makeMove(id, uciMove: move))) {
      throw ChessPlatformIllegalGameAction();
    }
  }
  
  @override
  Future<void> offerDraw() async {
    if (!(await lichess.handleDrawOffer(id, true))) {
      throw ChessPlatformIllegalGameAction();
    }
  }
  
  @override
  Future<void> resign() async {
    if (!(await lichess.resignGame(id))) {
      throw ChessPlatformIllegalGameAction();
    }
  }

  @override
  Future<void> sendMessage(String message) async {
    if (!(await lichess.writeInChat(id, message))) {
      throw ChessPlatformIllegalGameAction();
    }
  }

  /// Connect to lichess game stream
  Future<void> _connect() async {
    try {
      _stateController.setConnectionState(ChessGameConnectionState.connecting);
      final gameStream = await lichess.getGameStream(id);
      gameStreamSub = gameStream.listen(_handleGameEvent);
      _stateController.setConnectionState(ChessGameConnectionState.connected);
      _triggerInactivitiyReconnct();
    } catch (e) {
       _stateController.setConnectionState(ChessGameConnectionState.error, connectionError: ChessPlatformConnectionError(e));
    }
  }

  @override
  Future<void> reconnect() async {
    disconnect();
    await _connect();
  }

  void _handleGameEvent(LichessGameEvent event) {
    _triggerInactivitiyReconnct();

    if (event is LichessGameEventGameFull) {
      _updateFromState(event.state);
    }

    if (event is LichessGameEventGameState) {
      _updateFromState(event.state);
    }

    if (event is LichessGameEventChatLine) {
      _stateController.addChatMessage(username: event.username, content: event.text, createdAt: DateTime.now());
    }

    if (event is LichessGameEventOponnentGone) {
      _stateController.updateOpponentOnline(!event.gone, claimWinAt: !event.gone ? DateTime.now().add(Duration(seconds: event.claimWinInSeconds)) : DateTime(0));
    }
  }

  void _updateFromState(GameEventState? state) {
    List<String> moves = [];
    String movesStr = state?.moves ?? "";
    if (movesStr.isNotEmpty) {
      moves = movesStr.split(" ").toList();
    }

    _stateController.updateState(
      status: parseStatus(state?.status),
      moves: moves,
      whiteTime: Duration(milliseconds: state?.wtime ?? 0),
      blackTime: Duration(milliseconds: state?.btime ?? 0),
      whiteIncrement: Duration(milliseconds: state?.winc ?? 0),
      blackIncrement: Duration(milliseconds: state?.binc ?? 0),
      whiteOfferingDraw: state?.wdraw ?? false,
      blackOfferingDraw: state?.bdraw ?? false,
      whiteProposingTakeback: state?.wtakeback ?? false,
      blackProposingTakeback: state?.btakeback ?? false,
      winner: parseColor(state?.winner),
      clockRunning: moves.length >= 2,
      timeBase: DateTime.now(),
    );
  }

  void disconnect() {
    gameStreamSub?.cancel();
    gameStreamSub = null;
    _stateController.setConnectionState(ChessGameConnectionState.disconnected);
  }

  @override
  void dispose() {
    disconnect();
  }

}
