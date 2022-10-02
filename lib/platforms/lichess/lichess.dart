library open_chess_platform_api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/widgets.dart';
import 'package:open_chess_platform_api/chess_platform_credentials.dart';
import 'package:open_chess_platform_api/chess_platform_meta.dart';
import 'package:open_chess_platform_api/chess_platform_provider.dart';
import 'package:open_chess_platform_api/chess_platform_user.dart';
import 'package:open_chess_platform_api/exceptions/chess_platform_credentials_invalid.dart';
import 'package:open_chess_platform_api/exceptions/chess_platform_credentials_unsupported.dart';
import 'package:open_chess_platform_api/exceptions/chess_platform_http_exception.dart';
import 'package:open_chess_platform_api/models/chess_color_selection.dart';
import 'package:open_chess_platform_api/models/game.dart';
import 'package:open_chess_platform_api/models/time_option.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/events/lichess_event.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/events/lichess_event_game_started.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/game-events/lichess_game_event.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_account.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_challenge_result.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_game_import_result.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_options.dart';
import 'package:open_chess_platform_api/platforms/lichess/models/lichess_user.dart';

class Lichess extends ChessPlatform {
  final LichessOptions options;
  final HttpClient httpClient = HttpClient();

  String? token;
  LichessAccount? account;

  Lichess(this.options)
      : super(const ChessPlatformMeta(
            name: "Lichess",
            description:
                "Lichess is a free (really), libre, no-ads, open source chess server.",
            logo: AssetImage("lib/platforms/lichess/assets/logo.png"))) {
    httpClient.connectionTimeout = options.connectionTimeout;
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

  Future<Map<String, dynamic>> parseResponseJSON(
      HttpClientResponse response) async {
    if (response.statusCode == 200) {
      try {
        final text = await response.transform(utf8.decoder).join();
        return jsonDecode(text);
      } catch (e) {
        throw ChessPlatformHttpException(
            response, "Failed to parse response json");
      }
    } else if (response.statusCode == 401) {
      throw ChessPlatformNotAuthorizedException(response, "Not authorized");
    } else {
      throw ChessPlatformHttpException(response, "Failed to retrieve response");
    }
  }

  Future<String> getResponseText(HttpClientResponse response) async {
    final responseText = await response.transform(utf8.decoder).join();
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
    request.headers.contentType =
        ContentType("application", "json", charset: "utf-8");
    return request;
  }

  Future<HttpClientRequest> createPostRequest(path,
      {ContentType? contentType, List<int>? body}) async {
    HttpClientRequest request =
        await httpClient.postUrl(Uri.parse(options.lichessUrl + path));
    request.headers.set('Authorization', "Bearer $token");
    if (contentType != null) request.headers.contentType = contentType;
    if (body != null) {
      request.headers.set('Content-Length', body.length.toString());
      request.add(body);
    }
    return request;
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

  Future<LichessAccount> getAccount() async {
    final request = await createGetRequest("/api/account");
    final response = await request.close();
    final responseJson = await parseResponseJSON(response);
    return LichessAccount.fromJson(responseJson);
  }

  Future<List<LichessUser>> getFollowing() async {
    final request = await createGetRequest("/api/rel/following");
    final response = await request.close();
    final responseText = await getResponseText(response);

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
    return const LineSplitter()
        .bind(utf8.decoder.bind(response))
        .where((e) => e != "")
        .map((e) => LichessEvent.parseJson(jsonDecode(e)));
  }

  Future<Stream<LichessGameEvent>> getGameStream(String gameId) async {
    final request = await createGetRequest("/api/board/game/stream/$gameId");
    request.headers.set('Connection', 'Keep-Alive');
    request.headers.set('Keep-Alive', 'timeout=5, max=1000');
    final response = await request.close();
    return const LineSplitter()
        .bind(utf8.decoder.bind(response))
        .where((e) => e != "")
        .map((e) => LichessGameEvent.parseJson(jsonDecode(e)));
  }

  Future<Stream<List<int>>> getSeekStream(
      {bool rated = false,
      required TimeOption time,
      ChessColorSelection color = ChessColorSelection.random,
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
    final request = await createPostRequest("/api/challenge/open",
        contentType: ContentType("application", "x-www-form-urlencoded",
            charset: "utf-8"),
        body: body);

    final responseJson = await parseResponseJSON(await request.close());
    return LichessChallengeResult.fromJson(responseJson);
  }

  @override
  Future<LichessChallengeResult> createChallenge(
    String username, {
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
    final request = await createPostRequest("/api/challenge/$username",
        contentType: ContentType("application", "x-www-form-urlencoded",
            charset: "utf-8"),
        body: body);

    final responseJson = await parseResponseJSON(await request.close());
    return LichessChallengeResult.fromJson(responseJson);
  }

  Future<bool> makeMove(String gameId,
      {String uciMove = "", bool offerDraw = false}) async {
    final body = createFormBody({"offeringDraw": offerDraw});
    final request = await createPostRequest(
        "/api/board/game/$gameId/move/$uciMove",
        contentType: ContentType("application", "json", charset: "utf-8"),
        body: body);

    final responseJson = await parseResponseJSON(await request.close());
    return responseJson["ok"];
  }

  Future<bool> writeInChat(String gameId, String text,
      {String room = "player"}) async {
    final body = createFormBody({"room": room, "text": text});
    final request = await createPostRequest("/api/board/game/$gameId/chat",
        contentType: ContentType("application", "x-www-form-urlencoded",
            charset: "utf-8"),
        body: body);

    final responseJson = await parseResponseJSON(await request.close());
    return responseJson["ok"];
  }

  Future<bool> abortGame(String gameId) async {
    final request = await createPostRequest("/api/board/game/$gameId/abort",
        contentType: null);
    final responseJson = await parseResponseJSON(await request.close());
    return responseJson["ok"];
  }

  Future<bool> resignGame(String gameId) async {
    final request = await createPostRequest("/api/board/game/$gameId/resign",
        contentType: null);
    final responseJson = await parseResponseJSON(await request.close());
    return responseJson["ok"];
  }

  Future<bool> respondToDrawOffer(String gameId, bool accept) async {
    final request = await createPostRequest(
        "/api/board/game/$gameId/draw/" + (accept ? "yes" : "no"),
        contentType: null);
    final responseJson = await parseResponseJSON(await request.close());
    return responseJson["ok"];
  }

  Future<bool> acceptChallenge(String challengeId) async {
    final request = await createPostRequest(
        "/api/challenge/$challengeId/accept",
        contentType: null);
    final responseJson = await parseResponseJSON(await request.close());
    return responseJson["ok"];
  }

  Future<bool> declineChallenge(String challengeId) async {
    final request = await createPostRequest(
        "/api/challenge/$challengeId/decline",
        contentType: null);
    final responseJson = await parseResponseJSON(await request.close());
    return responseJson["ok"];
  }

  Future<bool> cancelChallenge(String challengeId) async {
    final request = await createPostRequest(
        "/api/challenge/$challengeId/cancel",
        contentType: null);
    final responseJson = await parseResponseJSON(await request.close());
    return responseJson["ok"];
  }

  Future<LichessGameImportResult> import(String pgn) async {
    final body = createFormBody({"pgn": pgn});
    final request = await createPostRequest("/api/import",
        contentType: ContentType("application", "x-www-form-urlencoded",
            charset: "utf-8"),
        body: body);

    final responseJson = await parseResponseJSON(await request.close());
    return LichessGameImportResult.fromJson(responseJson);
  }

  @override
  Future<CancelableOperation<GameResult>> seekGame(
      {bool rated = false,
      required TimeOption time,
      ChessColorSelection color = ChessColorSelection.random}) async {
    LichessEventGameStarted? lastEvent;
    late StreamSubscription eventListener;
    eventListener = (await listenForEvents()).listen((e) {
      if (e is LichessEventGameStarted) {
        lastEvent = e;
        eventListener.cancel();
      }
    });

    final seekListener =
        (await getSeekStream(rated: rated, time: time, color: color))
            .listen((_) {});

    return CancelableOperation.fromFuture(Future(() async {
      await seekListener.asFuture();
      await eventListener.asFuture();
      return lastEvent!.game;
    }), onCancel: () {
      seekListener.cancel();
      eventListener.cancel();
    });
  }

  @override
  Future<void> authenticate(ChessPlatformCredentials credentials) async {
    if (credentials is ChessPlatformCredentialsToken) {
      token = credentials.token;
      try {
        account = await getAccount();
      } catch (e) {
        throw ChessPlatformCredentialsInvalid();
      }
    } else {
      throw ChessPlatformCredentialsUnsupported();
    }
  }

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

  @override
  bool hasAuth() {
    return token != null;
  }
}
