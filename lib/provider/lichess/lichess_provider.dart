library chess_cloud_provider;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:chess_cloud_provider/chess_cloud_provider.dart';
import 'package:chess_cloud_provider/models/chess_color_selection.dart';
import 'package:chess_cloud_provider/models/game.dart';
import 'package:chess_cloud_provider/models/http_exception.dart';
import 'package:chess_cloud_provider/models/time_option.dart';
import 'package:chess_cloud_provider/provider/lichess/models/events/lichess_event.dart';
import 'package:chess_cloud_provider/provider/lichess/models/events/lichess_event_game_started.dart';
import 'package:chess_cloud_provider/provider/lichess/models/game-events/lichess_game_event.dart';
import 'package:chess_cloud_provider/provider/lichess/models/lichess_account.dart';
import 'package:chess_cloud_provider/provider/lichess/models/lichess_challenge_result.dart';
import 'package:chess_cloud_provider/provider/lichess/models/lichess_game_import_result.dart';
import 'package:chess_cloud_provider/provider/lichess/models/lichess_options.dart';
import 'package:chess_cloud_provider/provider/lichess/models/lichess_user.dart';

class LichessCloudProvider extends ChessCloudProvider {
  final LichessOptions options;
  final HttpClient httpClient = HttpClient();

  LichessCloudProvider(this.options) {
    httpClient.connectionTimeout = options.connectionTimeout;
  }

  List<int> createFormBody(Map<String, dynamic> entries) {
    String formBody = "";
    for (var entry in entries.entries) {
      formBody += entry.key + '=' + Uri.encodeQueryComponent(entry.value.toString()) + "&";
    }
    if (formBody != "") {
      formBody = formBody.substring(0, formBody.length - 1);
    }
    return utf8.encode(formBody);
  }

  Future<Map<String, dynamic>> parseResponseJSON(HttpClientResponse response) async {
    if (response.statusCode == 200) {
      try {
        final text = await response.transform(utf8.decoder).join();
        return jsonDecode(text);
      } catch (e) {
        throw ChessProviderHttpException(response, "Failed to parse response json");
      }
    } else if (response.statusCode == 401) {
      throw ChessProviderNotAuthorizedException(response, "Not authorized");
    } else {
      throw ChessProviderHttpException(response, "Failed to retrieve response");
    }
  }

  Future<HttpClientRequest> createGetRequest(path) async {
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(options.lichessUrl + path));
    request.headers.set('Authorization', "Bearer ${options.token}");
    request.headers.contentType = ContentType("application", "json", charset: "utf-8");
    return request;
  }
  
  Future<HttpClientRequest> createPostRequest(path, { ContentType? contentType, List<int>? body }) async {
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(options.lichessUrl + path));
    request.headers.set('Authorization', "Bearer ${options.token}");
    if (contentType != null) request.headers.contentType = contentType;
    if (body != null) {
      request.headers.set('Content-Length', body.length.toString());
      request.add(body);
    }
    return request;
  }

  Future<String> refreshToken() async {
    final request = await httpClient.postUrl(Uri.parse(options.tokenRefreshUrl));
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('Accept', 'text/plain;charset=UTF-8');
    final body = jsonEncode({
      "token": options.token,
    });
    
    request.headers.contentLength = body.length;
    request.write(body);

    final response = await request.close();

    if (response.statusCode == 200) {
      try {
        final newToken = await response.transform(utf8.decoder).join();
        options.token = newToken;
        return newToken;
      } catch (e) {
        throw ChessProviderHttpException(response, "Cannot parse new token");
      }
    } else {
      throw ChessProviderHttpException(response, "Failed to retrieve new token.");
    }
  }

  Future<LichessAccount> getAccount() async {
    final request = await createGetRequest("/api/account");
    final response = await request.close();
    final responseJson = await parseResponseJSON(response);
    return LichessAccount.fromJson(responseJson);
  }

  Future<List<LichessUser>> getFollowing(String username) async {
    final request = await createGetRequest("/api/rel/following");
    final response = await request.close();
    final responseText = await response.transform(utf8.decoder).join();

    return responseText
        .split("\n")
        .where((element) => element.length > 1)
        .map((item) => LichessUser.fromJson(jsonDecode(item)))
        .toList();
  }

  @override
  Future<Stream<LichessEvent>> listenForEvents() async {
    final request = await createGetRequest("/api/stream/event");
    request.headers.set('Connection', 'Keep-Alive');
    request.headers.set('Keep-Alive', 'timeout=5, max=1000');
    final response = await request.close();
    return const LineSplitter().bind(utf8.decoder.bind(response)).where((e) => e != "").map((e) => LichessEvent.parseJson(jsonDecode(e)));
  }

  Future<Stream<LichessGameEvent>> getGameStream(String gameId) async {
    final request = await createGetRequest("/api/board/game/stream/$gameId");
    request.headers.set('Connection', 'Keep-Alive');
    request.headers.set('Keep-Alive', 'timeout=5, max=1000');
    final response = await request.close();
    return const LineSplitter().bind(utf8.decoder.bind(response)).where((e) => e != "").map((e) => LichessGameEvent.parseJson(jsonDecode(e)));
  }

  Future<Stream<List<int>>> getSeekStream({
    bool rated = false,
    required TimeOption time,
    ChessColorSelection color = ChessColorSelection.random,
    List<int>? ratingRange
  }) async {

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
    final request = await createPostRequest("/api/board/seek", contentType: ContentType("application", "x-www-form-urlencoded", charset: "utf-8"), body: body);

    return request.close();
  }
  
  Future<LichessChallengeResult> createOpenChallenge({
    bool rated = false,
    TimeOption? time,
    ChessColorSelection color = ChessColorSelection.random,
  }) async {
    Map<String, dynamic> data = {"rated": rated, "color": color.text};

    if (time != null) {
      data["clock.limit"] = time.time.inMinutes;
      data["clock.increment"] = time.increment.inSeconds;
    }

    final body = createFormBody(data);
    final request = await createPostRequest("/api/challenge/open", contentType: ContentType("application", "x-www-form-urlencoded", charset: "utf-8"), body: body);

    final responseJson = await parseResponseJSON(await request.close());
    return LichessChallengeResult.fromJson(responseJson);
  }

  @override
  Future<LichessChallengeResult> createChallenge(String username, {
    bool rated = false,
    TimeOption? time,
    ChessColorSelection color = ChessColorSelection.random,
  }) async {
    Map<String, dynamic> data = {"rated": rated, "color": color.text};

    if (time != null) {
      data["clock.limit"] = time.time.inMinutes;
      data["clock.increment"] = time.increment.inSeconds;
    }

    final body = createFormBody(data);
    final request = await createPostRequest("/api/challenge/$username", contentType: ContentType("application", "x-www-form-urlencoded", charset: "utf-8"), body: body);

    final responseJson = await parseResponseJSON(await request.close());
    return LichessChallengeResult.fromJson(responseJson);
  }

  Future<bool> makeMove(String gameId, {String uciMove = "", bool offerDraw = false}) async {
    final body = createFormBody({"offeringDraw": offerDraw});
    final request = await createPostRequest("/api/board/game/$gameId/move/$uciMove", contentType: ContentType("application", "json", charset: "utf-8"), body: body);

    final responseJson = await parseResponseJSON(await request.close());
    return responseJson["ok"];
  }

  Future<bool> writeInChat(String gameId, String text, { String room = "player" }) async {
    final body = createFormBody({"room": room, "text": text});
    final request = await createPostRequest("/api/board/game/$gameId/chat", contentType: ContentType("application", "x-www-form-urlencoded", charset: "utf-8"), body: body);

    final responseJson = await parseResponseJSON(await request.close());
    return responseJson["ok"];
  }

  Future<bool> abortGame(String gameId) async {
    final request = await createPostRequest("/api/board/game/$gameId/abort", contentType: null);
    final responseJson = await parseResponseJSON(await request.close());
    return responseJson["ok"];
  }

  Future<bool> resignGame(String gameId) async {
    final request = await createPostRequest("/api/board/game/$gameId/resign", contentType: null);
    final responseJson = await parseResponseJSON(await request.close());
    return responseJson["ok"];
  }

  Future<bool> respondToDrawOffer(String gameId, bool accept) async {
    final request = await createPostRequest("/api/board/game/$gameId/draw/" + (accept ? "yes" : "no"), contentType: null);
    final responseJson = await parseResponseJSON(await request.close());
    return responseJson["ok"];
  }

  Future<bool> acceptChallenge(String challengeId) async {
    final request = await createPostRequest("/api/challenge/$challengeId/accept", contentType: null);
    final responseJson = await parseResponseJSON(await request.close());
    return responseJson["ok"];
  }

  Future<bool> declineChallenge(String challengeId) async {
    final request = await createPostRequest("/api/challenge/$challengeId/decline", contentType: null);
    final responseJson = await parseResponseJSON(await request.close());
    return responseJson["ok"];
  }

  Future<bool> cancelChallenge(String challengeId) async {
    final request = await createPostRequest("/api/challenge/$challengeId/cancel", contentType: null);
    final responseJson = await parseResponseJSON(await request.close());
    return responseJson["ok"];
  }

  Future<LichessGameImportResult> import(String pgn) async {
    final body = createFormBody({ "pgn": pgn });
    final request = await createPostRequest("/api/import", contentType: ContentType("application", "x-www-form-urlencoded", charset: "utf-8"), body: body);

    final responseJson = await parseResponseJSON(await request.close());
    return LichessGameImportResult.fromJson(responseJson);
  }

  @override
  Future<CancelableOperation<GameResult>> seekGame({bool rated = false, required TimeOption time, ChessColorSelection color = ChessColorSelection.random}) async {
    LichessEventGameStarted? lastEvent;
    late StreamSubscription eventListener;
    eventListener = (await listenForEvents()).listen((e) {
      if (e is LichessEventGameStarted) {
        lastEvent = e;
        eventListener.cancel();
      }
    });

    final seekListener = (await getSeekStream(rated: rated, time: time, color: color)).listen((_) {});

    return CancelableOperation.fromFuture(
      Future(() async {
        await seekListener.asFuture();
        await eventListener.asFuture();
        return lastEvent!.game;
      }),
      onCancel: () {
        seekListener.cancel();
        eventListener.cancel();
      }
    );
  }

}