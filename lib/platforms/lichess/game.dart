import 'dart:async';

import 'package:chess_cloud_provider/chess_game_state.dart';
import 'package:chess_cloud_provider/chess_platform_game.dart';
import 'package:chess_cloud_provider/platforms/lichess/lichess.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/game-events/lichess_game_event_opponent_gone.dart';
import 'package:chess_cloud_provider/platforms/lichess/utils.dart';

class LichessGame extends ChessPlatformGame {
  late final LichessGameInfo info;

  late final ChessGameStateController _stateController = ChessGameStateController();

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

  StreamSubscription<LichessGameEvent>? gameStreamSub;

  LichessGame({required this.info, required Lichess lichess}) {
    _attach(lichess);
  }

  void _attach(Lichess lichess) async {
    final gameStream = await lichess.getGameStream(id);
    gameStreamSub = gameStream.listen(_handleGameEvent);
  }

  void _handleGameEvent(LichessGameEvent event) {
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
    final moves = state?.moves.split(" ").toList() ?? [];
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

  // ignore: unused_element
  void dispose() {
    gameStreamSub?.cancel();
  }

}
