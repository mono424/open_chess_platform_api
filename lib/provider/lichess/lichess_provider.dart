library chess_cloud_provider;

import 'dart:convert';
import 'dart:io';

import 'package:chess_cloud_provider/chess_cloud_provider.dart';
import 'package:chess_cloud_provider/models/http_exception.dart';
import 'package:chess_cloud_provider/models/time_option.dart';
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
      formBody += entry.key + '=' + Uri.encodeQueryComponent(entry.value);
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
    } else {
      throw ChessProviderHttpException(response, "Failed to retrieve response");
    }
  }

  Future<HttpClientRequest> createGetRequest(path) async {
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(options.lichessUrl + path));
    request.headers.set('Authorization', "Bearer ${options.token}");
    request.headers.set('Content-Type', 'application/json');
    return request;
  }
  
  Future<HttpClientRequest> createPostRequest(path, { String? contentType = "application/json" }) async {
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(options.lichessUrl + path));
    request.headers.set('Authorization', "Bearer ${options.token}");
    if (contentType != null) request.headers.set('Content-Type', contentType);
    return request;
  }

  Future<void> refreshToken() async {
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

  Future<Stream<String>> getEventStream() async {
    final request = await createGetRequest("/api/stream/event");
    request.headers.set('Connection', 'Keep-Alive');
    request.headers.set('Keep-Alive', 'timeout=5, max=1000');
    final response = await request.close();
    return const LineSplitter().bind(utf8.decoder.bind(response));
  }

  Future<Stream<String>> getGameStream(String gameId) async {
    final request = await createGetRequest("/api/board/game/stream/$gameId");
    request.headers.set('Connection', 'Keep-Alive');
    request.headers.set('Keep-Alive', 'timeout=5, max=1000');
    final response = await request.close();
    return const LineSplitter().bind(utf8.decoder.bind(response));
  }

  Future<Stream<List<int>>> getSeekStream({
    bool rated = false,
    required TimeOption time,
    String color = "random",
    List<int>? ratingRange
  }) async {

    Map<String, dynamic> data = {
      "rated": rated,
      "color": color,
      "time": time.time.inMinutes,
      "increment": time.increment.inSeconds
    };

    if (ratingRange != null) {
      data["ratingRange"] = ratingRange.join("-");
    }

    final request = await createPostRequest("/api/board/seek", contentType: "application/x-www-form-urlencoded");
    final body = createFormBody(data);
    request.headers.contentLength = body.length;
    request.write(body);

    return request.close();
  }

  Future<LichessChallengeResult> createOpenChallenge({
    bool rated = false,
    TimeOption? time,
    String color = "random"
  }) async {
    Map<String, dynamic> data = {"rated": rated, "color": color};

    if (time != null) {
      data["clock.limit"] = time.time.inMinutes;
      data["clock.increment"] = time.increment.inSeconds;
    }

    final request = await createPostRequest("/api/challenge/open");
    final body = createFormBody(data);
    request.headers.contentLength = body.length;
    request.write(body);

    final responseJson = await parseResponseJSON(await request.close());
    return LichessChallengeResult.fromJson(responseJson);
  }

  Future<LichessChallengeResult> createChallenge(String username, {
    bool rated = false,
    TimeOption? time,
    String color = "random"
  }) async {
    Map<String, dynamic> data = {"rated": rated, "color": color};

    if (time != null) {
      data["clock.limit"] = time.time.inMinutes;
      data["clock.increment"] = time.increment.inSeconds;
    }

    final request = await createPostRequest("/api/challenge/$username");
    final body = createFormBody(data);
    request.headers.contentLength = body.length;
    request.write(body);

    final responseJson = await parseResponseJSON(await request.close());
    return LichessChallengeResult.fromJson(responseJson);
  }

  Future<bool> makeMove(String gameId, {String uciMove = "", bool offerDraw = false}) async {
    final request = await createPostRequest("/api/board/game/$gameId/move/$uciMove");

    final body = createFormBody({"offeringDraw": offerDraw});
    request.headers.contentLength = body.length;
    request.write(body);

    final responseJson = await parseResponseJSON(await request.close());
    return responseJson["ok"];
  }

  Future<bool> writeInChat(String gameId, String text, { String room = "player" }) async {
    final request = await createPostRequest("/api/board/game/$gameId/chat", contentType: "application/x-www-form-urlencoded");
    final body = createFormBody({"room": room, "text": text});
    request.headers.contentLength = body.length;
    request.write(body);

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
    final request = await createPostRequest("/api/import", contentType: "application/x-www-form-urlencoded");
    final body = createFormBody({ "pgn": pgn });
    request.headers.contentLength = body.length;
    request.write(body);

    final responseJson = await parseResponseJSON(await request.close());
    return LichessGameImportResult.fromJson(responseJson);
  }
}