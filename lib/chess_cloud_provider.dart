library chess_cloud_provider;

import 'package:async/async.dart';
import 'package:chess_cloud_provider/models/challenge_result.dart';
import 'package:chess_cloud_provider/models/chess_color_selection.dart';
import 'package:chess_cloud_provider/models/game.dart';
import 'package:chess_cloud_provider/models/provider_event.dart';
import 'package:chess_cloud_provider/models/time_option.dart';


abstract class ChessCloudProvider {

  Future<Stream<ProviderEvent>> listenForEvents();
  
  Future<ChallengeResult> createChallenge(String username, {
    bool rated = false,
    TimeOption time,
    ChessColorSelection color = ChessColorSelection.random,
  });

  Future<CancelableOperation<GameResult>> seekGame({
    bool rated = false,
    required TimeOption time,
    ChessColorSelection color = ChessColorSelection.random,
  });

}
