import 'dart:async';

import 'package:chess_cloud_provider/chess_platform_challenge.dart';
import 'package:chess_cloud_provider/chess_platform_exception.dart';
import 'package:chess_cloud_provider/chess_platform_game.dart';
import 'package:chess_cloud_provider/chess_platform_user.dart';
import 'package:chess_cloud_provider/models/chess_platform_auth_state.dart';
import 'package:chess_cloud_provider/models/chess_platform_connection_state.dart';

class ChessPlatformState<U extends ChessPlatformUser,
    G extends ChessPlatformGame, C extends ChessPlatformChallenge> {

  final Stream<ChessPlatformState<U, G, C>> _stream;

  U? user;
  ChessPlatformConnectionState connectionState = ChessPlatformConnectionState.disconnected;
  ChessPlatformException? connectionError;
  ChessPlatformAuthState auth = ChessPlatformAuthState.unauthenticated;
  ChessPlatformException? authError;
  List<G> runningGames = [];
  List<C> openChallenges = [];

  ChessPlatformState(this._stream);

  Stream<ChessPlatformState<U, G, C>> get stream {
    return _stream;
  }
}

class ChessPlatformStateController<U extends ChessPlatformUser,
    G extends ChessPlatformGame, C extends ChessPlatformChallenge> {
  final StreamController<ChessPlatformState<U, G, C>> _streamController =
      StreamController();

  late final ChessPlatformState<U, G, C> state =
      ChessPlatformState<U, G, C>(_streamController.stream.asBroadcastStream());

  ChessPlatformStateController();

  void setAuthenticated(ChessPlatformAuthState authenticated, { ChessPlatformException? authenticationError }) {
    state.auth = authenticated;
    state.authError = authenticationError;
    _notify();
  }

  void setConnectionState(ChessPlatformConnectionState connectionState, { ChessPlatformException? connectionError }) {
    state.connectionState = connectionState;
    state.connectionError = connectionError;
    _notify();
  }

  void reset() {
    state.user = null;
    state.runningGames = [];
    state.openChallenges = [];
    _notify();
  }


  void setUser(U? user) {
    state.user = user;
    _notify();
  }

  void addRunningGame(G game) {
    state.runningGames.add(game);
    _notify();
  }

  void removeRunningGame(String gameId) {
    state.runningGames.removeWhere((e) => e.id == gameId);
    _notify();
  }

  void addOpenChallenge(C challenge) {
    state.openChallenges.add(challenge);
    _notify();
  }

  void removeOpenChallenge(String challengeId) {
    state.openChallenges.removeWhere((e) => e.id == challengeId);
    _notify();
  }

  void _notify() {
    _streamController.add(state);
  }
}
