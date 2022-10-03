import 'package:open_chess_platform_api/chess_platform_challenge.dart';
import 'package:open_chess_platform_api/chess_platform_game.dart';
import 'package:open_chess_platform_api/chess_platform_user.dart';

class ChessPlatformState<U extends ChessPlatformUser,
    G extends ChessPlatformGame, C extends ChessPlatformChallenge> {
  U? user;

  List<G> runningGames = [];
  List<C> openChallenges = [];
}

class ChessPlatformStateController<U extends ChessPlatformUser,
    G extends ChessPlatformGame, C extends ChessPlatformChallenge> {
  late final ChessPlatformState<U, G, C> state;

  ChessPlatformStateController(this.state);

  void setUser(U? user) {
    state.user = user;
  }

  void addRunningGame(G game) {
    state.runningGames.add(game);
  }

  void removeRunningGame(String gameId) {
    state.runningGames.removeWhere((e) => e.id == gameId);
  }

  void addOpenChallenge(C challenge) {
    state.openChallenges.add(challenge);
  }

  void removeOpenChallenge(String challengeId) {
    state.openChallenges.removeWhere((e) => e.id == challengeId);
  }
}
