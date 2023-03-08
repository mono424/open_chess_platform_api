library chess_cloud_provider;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:chess_cloud_provider/exceptions/chess_platform_auth_in_progress.dart';
import 'package:chess_cloud_provider/exceptions/chess_platform_challenge_declined.dart';
import 'package:chess_cloud_provider/exceptions/chess_platform_connection_error.dart';
import 'package:chess_cloud_provider/exceptions/chess_platform_illegal_action.dart';
import 'package:chess_cloud_provider/exceptions/chess_platform_timeout.dart';
import 'package:chess_cloud_provider/models/challenge_request.dart';
import 'package:chess_cloud_provider/chess_platform_logger.dart';
import 'package:chess_cloud_provider/models/chess_platform_auth_state.dart';
import 'package:chess_cloud_provider/models/chess_platform_connection_state.dart';
import 'package:chess_cloud_provider/platforms/lichess/game.dart';
import 'package:chess_cloud_provider/platforms/lichess/utils.dart';
import 'package:flutter/widgets.dart';
import 'package:chess_cloud_provider/chess_platform_challenge.dart';
import 'package:chess_cloud_provider/chess_platform_credentials.dart';
import 'package:chess_cloud_provider/chess_platform_game.dart';
import 'package:chess_cloud_provider/chess_platform_meta.dart';
import 'package:chess_cloud_provider/chess_platform.dart';
import 'package:chess_cloud_provider/chess_platform_state.dart';
import 'package:chess_cloud_provider/chess_platform_user.dart';
import 'package:chess_cloud_provider/exceptions/chess_platform_credentials_invalid.dart';
import 'package:chess_cloud_provider/exceptions/chess_platform_credentials_unsupported.dart';
import 'package:chess_cloud_provider/exceptions/chess_platform_http_exception.dart';
import 'package:chess_cloud_provider/models/chess_color.dart';
import 'package:chess_cloud_provider/models/chess_rating_range.dart';
import 'package:chess_cloud_provider/models/time_option.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/events/lichess_event.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/events/lichess_event_challenge.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/events/lichess_event_challenge_canceled.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/events/lichess_event_challenge_declined.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/events/lichess_event_game_finish.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/events/lichess_event_game_started.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/game-events/lichess_game_event.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/lichess_account.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/lichess_challenge.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/lichess_challenge_result.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/lichess_game_import_result.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/lichess_options.dart';
import 'package:chess_cloud_provider/platforms/lichess/models/lichess_user.dart';

export 'package:chess_cloud_provider/exceptions/chess_platform_credentials_invalid.dart';
export 'package:chess_cloud_provider/exceptions/chess_platform_credentials_unsupported.dart';
export 'package:chess_cloud_provider/exceptions/chess_platform_http_exception.dart';

export 'package:chess_cloud_provider/models/challenge_result.dart';
export 'package:chess_cloud_provider/models/chess_color.dart';
export 'package:chess_cloud_provider/models/game_time_type.dart';
export 'package:chess_cloud_provider/models/platform_event.dart';
export 'package:chess_cloud_provider/models/time_option.dart';

export 'package:chess_cloud_provider/platforms/lichess/models/lichess_account.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_challeng_participant.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_challenge.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_challenge_result.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_clock.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_compat.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_count.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_game_info.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_game_event_player.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_game_event_state.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_game_import_result.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_opponent.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_options.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_perf.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_playtime.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_rating_info.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_time_control.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_user.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_user_ratings.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/lichess_variant.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/events/lichess_event.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/events/lichess_event_challenge.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/events/lichess_event_challenge_canceled.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/events/lichess_event_challenge_declined.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/events/lichess_event_game_finish.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/events/lichess_event_game_started.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/game-events/lichess_game_event.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/game-events/lichess_game_event_chat_line.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/game-events/lichess_game_event_game_full.dart';
export 'package:chess_cloud_provider/platforms/lichess/models/game-events/lichess_game_event_game_state.dart';

class Lichess extends ChessPlatform {
  final LichessOptions options;
  late final HttpClient httpClient;

  // Handles the outstream.
  final StreamController<LichessEvent> _outStreamController =
      StreamController();
  late final Stream<LichessEvent> outStream =
      _outStreamController.stream.asBroadcastStream();

  // Managed State
  late final ChessPlatformStateController<LichessUser, LichessGame, LichessChallenge> _stateController =
      ChessPlatformStateController<LichessUser, LichessGame,
          LichessChallenge>();

  // Authentication
  String? token;

  // Original EventStream from lichess.
  Stream<LichessEvent>? _eventStream;
  StreamSubscription<LichessEvent>? _eventStreamSub;

  Lichess(this.options, { ChessPlatformLogger logger = const DummyLogger() })
      : super(const ChessPlatformMeta(
            name: "Lichess",
            description:
                "Lichess is a free (really), libre, no-ads, open source chess server.",
            logo: AssetImage("assets/lichess.png",
                package: "chess_cloud_provider")), logger: logger) {
    httpClient = options.httpClient ?? HttpClient();
    httpClient.connectionTimeout = options.connectionTimeout;
    httpClient.idleTimeout = options.idleTimeout;
  }

  //        d8888          888    888
  //       d88888          888    888
  //      d88P888          888    888
  //     d88P 888 888  888 888888 88888b.
  //    d88P  888 888  888 888    888 "88b
  //   d88P   888 888  888 888    888  888
  //  d8888888888 Y88b 888 Y88b.  888  888
  // d88P     888  "Y88888  "Y888 888  888

  @override
  Future<void> authenticate(ChessPlatformCredentials credentials) async {
    if (_stateController.state.auth == ChessPlatformAuthState.loading) {
      throw ChessPlatformAuthInProgress();
    }

    if (_stateController.state.auth == ChessPlatformAuthState.authenticated) {
      await deauthenticate();
    }

    if (credentials is ChessPlatformCredentialsToken) {
      token = credentials.token;
      try {
         _stateController.setAuthenticated(ChessPlatformAuthState.loading);
        final account = await getAccount();
        _stateController.setAuthenticated(ChessPlatformAuthState.authenticated);
        _stateController.setUser(account);
        await setupState();
      } catch (e) {
        final err = ChessPlatformCredentialsInvalid();
        _stateController.setAuthenticated(ChessPlatformAuthState.error, authenticationError: err);
        throw err;
      }
    } else {
      final err = ChessPlatformCredentialsUnsupported();
      _stateController.setAuthenticated(ChessPlatformAuthState.error, authenticationError: err);
      throw err;
    }
  }

  @override
  bool hasAuth() {
    return _stateController.state.auth == ChessPlatformAuthState.authenticated;
  }

  @override
  Future<void> deauthenticate() async {
    token = null;
    _stateController.setAuthenticated(ChessPlatformAuthState.unauthenticated);
    _stateController.setUser(null);
    disposeState();
  }

  Future<String> refreshToken() async {
    final request =
        await httpClient.postUrl(Uri.parse(options.tokenRefreshUrl));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Accept', 'text/plain;charset=UTF-8');
    final body = jsonEncode({
      "token": token ?? "",
    });

    request.headers.contentLength = body.length;
    request.write(body);

    final response = await request.close();

    if (response.statusCode == 200) {
      try {
        final newToken = await response.transform(utf8.decoder).join();
        token = newToken;
        return newToken;
      } catch (e) {
        throw ChessPlatformHttpException(response, "Cannot parse new token");
      }
    } else {
      throw ChessPlatformHttpException(
          response, "Failed to retrieve new token.");
    }
  }

  //        d8888 8888888b. 8888888
  //       d88888 888   Y88b  888
  //      d88P888 888    888  888
  //     d88P 888 888   d88P  888
  //    d88P  888 8888888P"   888
  //   d88P   888 888         888
  //  d8888888888 888         888
  // d88P     888 888       8888888

  Future<LichessAccount> getAccount({ int? retries, Duration? retryDelay }) async {
    final retriesVal = retries ?? options.defaultRetries;
    final retryDelayVal = retryDelay ?? options.defaultRetryDelay;

    return retryAsync<LichessAccount>(() async {
      final request = await createGetRequest("/api/account");
      _logRequest(request);
      final response = await request.close();
      final responseJson = await parseResponseJSON(response);
      return LichessAccount.fromJson(responseJson);
    }, retries: retriesVal, retryDelay: retryDelayVal);
  }

  Future<List<LichessUser>> getFollowing({ int? retries, Duration? retryDelay }) async {
    final retriesVal = retries ?? options.defaultRetries;
    final retryDelayVal = retryDelay ?? options.defaultRetryDelay;

    return retryAsync<List<LichessUser>>(() async {
      final request = await createGetRequest("/api/rel/following");
      _logRequest(request);
      final response = await request.close();
      final responseText = await getResponseText(response);

      return responseText
          .split("\n")
          .where((element) => element.length > 1)
          .map((item) => LichessUser.fromJson(jsonDecode(item)))
          .toList();
    }, retries: retriesVal, retryDelay: retryDelayVal);
  }

  Future<LichessChallengeResult> createOpenChallenge({
    bool rated = false,
    TimeOption? time,
    ChessColor color = ChessColor.random,
    int? retries,
    Duration? retryDelay,
  }) async {
    final retriesVal = retries ?? options.defaultRetries;
    final retryDelayVal = retryDelay ?? options.defaultRetryDelay;

    Map<String, dynamic> data = {"rated": rated, "color": color.text};
    if (time != null) {
      data["clock.limit"] = time.time.inSeconds;
      data["clock.increment"] = time.increment.inSeconds;
    }

    final body = createFormBody(data);

    return retryAsync<LichessChallengeResult>(() async {
      final request = await createPostRequest("/api/challenge/open",
          contentType: ContentType("application", "x-www-form-urlencoded",
              charset: "utf-8"),
          body: body);
      _logRequest(request, body: body);
      final responseJson = await parseResponseJSON(await request.close());
      return LichessChallengeResult.fromJson(responseJson);
    }, retries: retriesVal, retryDelay: retryDelayVal);
  }

  Future<LichessChallengeResult> createNewChallenge(
    String userId, {
    bool rated = false,
    TimeOption? time,
    ChessColor color = ChessColor.random,
    int? retries,
    Duration? retryDelay,
  }) async {
    final retriesVal = retries ?? options.defaultRetries;
    final retryDelayVal = retryDelay ?? options.defaultRetryDelay;

    Map<String, dynamic> data = {"rated": rated, "color": color.text};
    if (time != null) {
      data["clock.limit"] = time.time.inSeconds;
      data["clock.increment"] = time.increment.inSeconds;
    }

    final body = createFormBody(data);

    return retryAsync<LichessChallengeResult>(() async {
      final request = await createPostRequest("/api/challenge/$userId",
          contentType: ContentType("application", "x-www-form-urlencoded",
              charset: "utf-8"),
          body: body);
      _logRequest(request, body: body);
      final responseJson = await parseResponseJSON(await request.close());
      return LichessChallengeResult.fromJson(responseJson);
    }, retries: retriesVal, retryDelay: retryDelayVal);
  }

  Future<bool> makeMove(String gameId, { String uciMove = "", bool offerDraw = false, int? retries, Duration? retryDelay }) async {
    final body = createFormBody({"offeringDraw": offerDraw});
    final retriesVal = retries ?? options.defaultRetries;
    final retryDelayVal = retryDelay ?? options.defaultRetryDelay;

    return retryAsync<bool>(() async {
      final request = await createPostRequest(
        "/api/board/game/$gameId/move/$uciMove",
        contentType: ContentType("application", "json", charset: "utf-8"),
        body: body
      );
      _logRequest(request, body: body);
      final responseJson = await parseResponseJSON(await request.close());
      return responseJson["ok"];
    }, retries: retriesVal, retryDelay: retryDelayVal);
  }

  Future<bool> writeInChat(String gameId, String text, { String room = "player", int? retries, Duration? retryDelay }) async {
    final body = createFormBody({"room": room, "text": text});
    final retriesVal = retries ?? options.defaultRetries;
    final retryDelayVal = retryDelay ?? options.defaultRetryDelay;

    return retryAsync<bool>(() async {
      final request = await createPostRequest("/api/board/game/$gameId/chat",
        contentType: ContentType("application", "x-www-form-urlencoded",
            charset: "utf-8"),
        body: body);
      _logRequest(request, body: body);
      final responseJson = await parseResponseJSON(await request.close());
      return responseJson["ok"];
    }, retries: retriesVal, retryDelay: retryDelayVal);
  }

  Future<bool> abortGame(String gameId, { int? retries, Duration? retryDelay }) async {
    final request = await createPostRequest("/api/board/game/$gameId/abort", contentType: null);
    final retriesVal = retries ?? options.defaultRetries;
    final retryDelayVal = retryDelay ?? options.defaultRetryDelay;

    return retryAsync<bool>(() async {
      _logRequest(request);
      final responseJson = await parseResponseJSON(await request.close());
      return responseJson["ok"];
    }, retries: retriesVal, retryDelay: retryDelayVal);
  }

  Future<bool> resignGame(String gameId, { int? retries, Duration? retryDelay }) async {
    final request = await createPostRequest("/api/board/game/$gameId/resign", contentType: null);
    final retriesVal = retries ?? options.defaultRetries;
    final retryDelayVal = retryDelay ?? options.defaultRetryDelay;

    return retryAsync<bool>(() async {
      _logRequest(request);
      final responseJson = await parseResponseJSON(await request.close());
      return responseJson["ok"];
    }, retries: retriesVal, retryDelay: retryDelayVal);
  }

  Future<bool> handleDrawOffer(String gameId, bool accept, { int? retries, Duration? retryDelay }) async {
    final request = await createPostRequest("/api/board/game/$gameId/draw/" + (accept ? "yes" : "no"), contentType: null);
    final retriesVal = retries ?? options.defaultRetries;
    final retryDelayVal = retryDelay ?? options.defaultRetryDelay;

    return retryAsync<bool>(() async {
      _logRequest(request);
      final responseJson = await parseResponseJSON(await request.close());
      return responseJson["ok"];
    }, retries: retriesVal, retryDelay: retryDelayVal);
  }

  @override
  Future<ChessPlatformGame> acceptChallenge(String challengeId, { int? retries, Duration? retryDelay }) async {
    final request = await createPostRequest("/api/challenge/$challengeId/accept", contentType: null);
    final retriesVal = retries ?? options.defaultRetries;
    final retryDelayVal = retryDelay ?? options.defaultRetryDelay;

    return retryAsync<ChessPlatformGame>(() async {
      _logRequest(request);
      final responseJson = await parseResponseJSON(await request.close());
      
      if (!responseJson["ok"]) {
        throw ChessPlatformIllegalAction();
      }

      late StreamSubscription eventListener;
      ChessPlatformGame? startedGame;

      eventListener = _stateController.state.stream.listen((e) {
        final games = e.runningGames.where((LichessGame e) => e.id == challengeId);
        if (games.isNotEmpty) {
          startedGame = games.first;
          eventListener.cancel();
          return;
        }
      });

      await Future.any([
        eventListener.asFuture(),
        Future.delayed(const Duration(seconds: 10))
      ]);

      ChessPlatformGame? lStartedGame = startedGame;
      if (lStartedGame == null) {
        eventListener.cancel();
        throw ChessPlatformTimeout();
      }

      return lStartedGame;
    }, retries: retriesVal, retryDelay: retryDelayVal);
  }

  @override
  Future<void> declineChallenge(String challengeId, { int? retries, Duration? retryDelay }) async {
    final request = await createPostRequest("/api/challenge/$challengeId/decline", contentType: null);
    final retriesVal = retries ?? options.defaultRetries;
    final retryDelayVal = retryDelay ?? options.defaultRetryDelay;

    return retryAsync<void>(() async {
      _logRequest(request);
      final responseJson = await parseResponseJSON(await request.close());
      
      if (!responseJson["ok"]) {
        throw ChessPlatformIllegalAction();
      }
    }, retries: retriesVal, retryDelay: retryDelayVal);
  }

  @override
  Future<void> cancelChallenge(String challengeId, { int? retries, Duration? retryDelay }) async {
    final request = await createPostRequest("/api/challenge/$challengeId/cancel", contentType: null);
    final retriesVal = retries ?? options.defaultRetries;
    final retryDelayVal = retryDelay ?? options.defaultRetryDelay;

    return retryAsync<void>(() async {
      _logRequest(request);
      final responseJson = await parseResponseJSON(await request.close());

      if (!responseJson["ok"]) {
        throw ChessPlatformIllegalAction();
      }
    }, retries: retriesVal, retryDelay: retryDelayVal);
  }

  Future<LichessGameImportResult> import(String pgn, { int? retries, Duration? retryDelay }) async {
    final retriesVal = retries ?? options.defaultRetries;
    final retryDelayVal = retryDelay ?? options.defaultRetryDelay;
    
    return retryAsync<LichessGameImportResult>(() async {
      final body = createFormBody({"pgn": pgn});
      final request = await createPostRequest("/api/import",
          contentType: ContentType("application", "x-www-form-urlencoded",
              charset: "utf-8"),
          body: body);
      _logRequest(request, body: body);
      final responseJson = await parseResponseJSON(await request.close());
      return LichessGameImportResult.fromJson(responseJson);
     }, retries: retriesVal, retryDelay: retryDelayVal);
  }

  /// Stream API

  Future<Stream<LichessEvent>> openEventStream() async {
    final request = await createGetRequest("/api/stream/event");
    request.headers.set('Connection', 'Keep-Alive');
    request.headers.set('Keep-Alive', 'timeout=5, max=1000');
    _logRequest(request);
    final response = await request.close();
    return const LineSplitter()
        .bind(utf8.decoder.bind(response))
        .where((e) => e != "")
        .map((e) {
          logger.messageIn("[EventStream] $e");
          return LichessEvent.parseJson(jsonDecode(e));
        });
  }

  @override
  Future<Stream<LichessEvent>> listenForEvents() async {
    return outStream;
  }

  Future<Stream<LichessGameEvent>> getGameStream(String gameId) async {
    final request = await createGetRequest("/api/board/game/stream/$gameId");
    request.headers.set('Connection', 'Keep-Alive');
    request.headers.set('Keep-Alive', 'timeout=5, max=1000');
    _logRequest(request);
    final response = await request.close();
    return const LineSplitter()
        .bind(utf8.decoder.bind(response))
        .where((e) => e != "")
        .map((e) {
          logger.messageIn("[GameStream] $e");
          return LichessGameEvent.parseJson(jsonDecode(e));
        });
  }

  Future<Stream<List<int>>> getSeekStream(
      {bool rated = false,
      required TimeOption time,
      ChessColor color = ChessColor.random,
      List<int>? ratingRange}) async {
    Map<String, dynamic> data = {
      "rated": rated,
      "color": color.text,
      "time": time.time.inMinutes,
      "increment": time.increment.inSeconds
    };

    if (ratingRange != null) {
      data["ratingRange"] = ratingRange.join("-");
    }

    final body = createFormBody(data);
    final request = await createPostRequest("/api/board/seek",
        contentType: ContentType("application", "x-www-form-urlencoded",
            charset: "utf-8"),
        body: body);
    _logRequest(request, body: body);
    return request.close();
  }

  @override
  Future<CancelableOperation<ChessPlatformGame>> seekGame(
      {bool rated = false,
      required TimeOption time,
      ChessColor color = ChessColor.random,
      ChessRatingRange? ratingRange}) async {

    late StreamSubscription eventListener;
   Completer<ChessPlatformGame> gameCompleter = Completer<ChessPlatformGame>();

    eventListener = _stateController.state.stream.listen((e) {
      final games = e.runningGames.where((LichessGame e) => e.info.source == "lobby");
      if (games.isNotEmpty) {
        gameCompleter.complete(games.first);
        eventListener.cancel();
      }
    });

    final seekListener =
        (await getSeekStream(rated: rated, time: time, color: color))
            .listen((_) {});

    return CancelableOperation.fromFuture(gameCompleter.future, onCancel: () {
      seekListener.cancel();
      eventListener.cancel();
    });
  }

  @override
  Future<ChallengeRequest> createChallenge(
    String userId, {
    bool rated = false,
    required TimeOption time,
    ChessColor color = ChessColor.random,
  }) async {

    late StreamSubscription eventListener;
    Completer<ChessPlatformGame> gameCompleter = Completer<ChessPlatformGame>();

    final challenge = await createNewChallenge(userId,
        rated: rated, time: time, color: color);

    eventListener = _stateController.state.stream.listen((e) {
      final games = e.runningGames.where((LichessGame e) => e.id == challenge.getChallengeId());
      if (games.isNotEmpty) {
        gameCompleter.complete(games.first);
        eventListener.cancel();
        return;
      }

      if (!e.openChallenges.any((e) => e.id == challenge.getChallengeId())) {
        gameCompleter.completeError(ChessPlatformChallengeDeclined());
        eventListener.cancel();
        return;
      }
    });

    return ChallengeRequest(CancelableOperation.fromFuture(
      gameCompleter.future,
      onCancel: () async {
      await Future.wait([
        eventListener.cancel(),
        cancelChallenge(challenge.getChallengeId())
      ]);
    }), challenge.getChallengeId());
  }

  /// Convience

  @override
  Future<List<ChessPlatformUser>> getFriend(String query) async {
    List<ChessPlatformUser> result = [];
    for (var res in (await getFollowing())) {
      if (query == "" || res.username.replaceFirst(query, "") != res.username) {
        result.add(res);
      }
    }
    return result;
  }

  //   .d8888b. 88888888888     d8888 88888888888 8888888888
  // d88P  Y88b    888        d88888     888     888
  // Y88b.         888       d88P888     888     888
  //  "Y888b.      888      d88P 888     888     8888888
  //     "Y88b.    888     d88P  888     888     888
  //       "888    888    d88P   888     888     888
  // Y88b  d88P    888   d8888888888     888     888
  //  "Y8888P"     888  d88P     888     888     8888888888

  @override
  ChessPlatformState<ChessPlatformUser, ChessPlatformGame,
      ChessPlatformChallenge> getState() {
    return _stateController.state;
  }

  void disposeState() {
    if (_eventStreamSub != null) {
      _eventStreamSub!.cancel();
      _eventStream = null;
      _eventStreamSub = null;
      _stateController.setConnectionState(ChessPlatformConnectionState.disconnected);
    }
  }

  Future<void> setupState() async {
    disposeState();
    _stateController.setConnectionState(ChessPlatformConnectionState.connecting);
    try {
      _eventStream = await openEventStream();
      _eventStreamSub = _eventStream!.listen(handleEvent);
      _stateController.setConnectionState(ChessPlatformConnectionState.connected);
    } catch (e) {
      _stateController.setConnectionState(ChessPlatformConnectionState.error, connectionError: ChessPlatformConnectionError(e));
    }
  }

  void handleEvent(LichessEvent event) {
    _outStreamController.add(event);

    if (event is LichessEventGameStarted) {
      _stateController.removeOpenChallenge(event.game.gameId);
      _stateController.addRunningGame(LichessGame(info: event.game, lichess: this));
    }

    if (event is LichessEventGameFinish) {
      _stateController.removeRunningGame(event.game.gameId);
    }

    if (event is LichessEventChallenge) {
      _stateController.addOpenChallenge(event.challenge);
    }

    if (event is LichessEventChallengeCanceled) {
      _stateController.removeOpenChallenge(event.challenge.id);
    }

    if (event is LichessEventChallengeDeclined) {
      _stateController.removeOpenChallenge(event.challenge.id);
    }
  }

  // 888     888 888    d8b 888
  // 888     888 888    Y8P 888
  // 888     888 888        888
  // 888     888 888888 888 888 .d8888b
  // 888     888 888    888 888 88K
  // 888     888 888    888 888 "Y8888b.
  // Y88b. .d88P Y88b.  888 888      X88
  // "Y88888P"   "Y888 888 888  88888P'

  Future<Map<String, dynamic>> parseResponseJSON(
      HttpClientResponse response) async {
    if (response.statusCode == 200) {
      try {
        final text = await response.transform(utf8.decoder).join();
        logger.messageIn("[HttpResponse] $text");
        return jsonDecode(text);
      } catch (e) {
        throw ChessPlatformHttpException(
            response, "Failed to parse response json");
      }
    } else if (response.statusCode == 401) {
      String text = "";
      try {
        text = await response.transform(utf8.decoder).join();
      } catch (e) {}
      throw ChessPlatformNotAuthorizedException(response, "Not authorized: " + text);
    } else {
      String text = "";
      try {
        text = await response.transform(utf8.decoder).join();
      } catch (e) {}
      throw ChessPlatformHttpException(response, "Failed to retrieve response: " + text);
    }
  }

  Future<String> getResponseText(HttpClientResponse response) async {
    final responseText = await response.transform(utf8.decoder).join();
    logger.messageIn("[HttpResponse] $responseText");

    if (response.statusCode == 200) {
      return responseText;
    }

    String errorDescription;
    try {
      final json = jsonDecode(responseText);
      errorDescription = json["error"];
    } catch (e) {
      errorDescription = "Failed to parse response json";
    }

    if (response.statusCode == 401) {
      throw ChessPlatformNotAuthorizedException(response, errorDescription);
    } else {
      throw ChessPlatformHttpException(response, errorDescription);
    }
  }

  Future<HttpClientRequest> createGetRequest(path) async {
    HttpClientRequest request =
        await httpClient.getUrl(Uri.parse(options.lichessUrl + path));
    if (token != null) {
      request.headers.set('Authorization', "Bearer $token");
    }
    if (options.userAgent != null) {
      request.headers.set('User-Agent', options.userAgent!);
    }
    request.headers.contentType =
        ContentType("application", "json", charset: "utf-8");
    return request;
  }

  Future<HttpClientRequest> createPostRequest(path,
      {ContentType? contentType, List<int>? body}) async {
    HttpClientRequest request =
        await httpClient.postUrl(Uri.parse(options.lichessUrl + path));
    request.headers.set('Authorization', "Bearer $token");
    if (options.userAgent != null) {
      request.headers.set('User-Agent', options.userAgent!);
    }
    if (contentType != null) request.headers.contentType = contentType;
    if (body != null) {
      request.headers.set('Content-Length', body.length.toString());
      request.add(body);
    }
    return request;
  }

  List<int> createFormBody(Map<String, dynamic> entries) {
    String formBody = "";
    for (var entry in entries.entries) {
      formBody += entry.key +
          '=' +
          Uri.encodeQueryComponent(entry.value.toString()) +
          "&";
    }
    if (formBody != "") {
      formBody = formBody.substring(0, formBody.length - 1);
    }
    return utf8.encode(formBody);
  }

  void _logRequest(HttpClientRequest req, { List<int>? body }) {
    if (logger is DummyLogger) {
      return;
    }

    logger.messageOut("[${req.method}] ${req.uri}");
    req.headers.forEach((key, value) {
      if (key.toLowerCase() == "authorization") {
        logger.messageOut(" > Header: $key: ********");
        return;
      }
      logger.messageOut(" > Header: $key: $value");
    });
    if (body != null) {
      logger.messageOut(" > Body: ${utf8.decode(body)}");
    }
  }
}
