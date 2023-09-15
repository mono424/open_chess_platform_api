import 'dart:async';

import 'package:open_chess_platform_api/models/game_status.dart';
import 'package:open_chess_platform_api/platforms/lichess/lichess.dart';

Future<T> retryAsync<T>(Future<T> Function() fn, { required int retries, required Duration retryDelay }) async {
    try {
      return await fn();
    } catch (e) {
      if (retries > 0) {
        await Future.delayed(retryDelay);
        return retryAsync(fn, retries: retries - 1, retryDelay: retryDelay);
      }
      rethrow;
    }
}

void Function() debounce(void Function() fn, { required Duration duration }) {
  Timer? timer;
  
  return () {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(duration, () {
      fn();
    });
  };
}

GameTimeType parseSpeed(String speed) {
  switch (speed.toLowerCase()) {
    case "bullet":
      return GameTimeType.bullet;
    case "blitz":
      return GameTimeType.blitz;
    case "rapid":
      return GameTimeType.rapid;
    case "classical":
      return GameTimeType.classical;
    case "correspondence":
      return GameTimeType.correspondence;
    default:
      throw Exception("Unknown speed: $speed");
  }
}

ChessColor? parseColor(String? color) {
  if (color == null) {
    return null;
  }

  switch (color.toLowerCase()) {
    case "white":
      return ChessColor.white;
    case "black":
      return ChessColor.black;
    default:
      throw Exception("Unknown color: $color");
  }
}
 
GameStatus parseStatus(String? status) {
  if (status == null) {
    return GameStatus.unknown;
  }

  switch (status.toLowerCase()) {
    case "created":
    case "started":
      return GameStatus.started;
    case "mate":
      return GameStatus.mate;
    case "resign":
      return GameStatus.resign;
    case "stalemate":
      return GameStatus.stalemate;
    case "timeout":
      return GameStatus.timeout;
    case "draw":
      return GameStatus.draw;
    case "outoftime":
      return GameStatus.outoftime;
    case "cheat":
      return GameStatus.cheat;
    case "aborted":
    case "noStart":
    case "unknownFinish":
    case "variantEnd":
      return GameStatus.aborted;
    default:
      throw Exception("Unknown status: $status");
  }
}