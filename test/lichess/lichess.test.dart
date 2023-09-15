import 'dart:convert';
import 'dart:io';

import 'package:open_chess_platform_api/chess_platform_credentials.dart';
import 'package:open_chess_platform_api/platforms/lichess/lichess.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:mockito/annotations.dart';

import 'lichess.test.data.dart';
import 'lichess.test.mocks.dart';

@GenerateNiceMocks([MockSpec<HttpClient>(), MockSpec<HttpClientRequest>(), MockSpec<HttpClientResponse>(), MockSpec<HttpHeaders>()])

class FakeHttpClientRequest extends MockHttpClientRequest implements HttpClientRequest {
  @override
  final headers = MockHttpHeaders();
}

void main() {
  const userAgent =  "TestApp/123.456";
  const lichessUrl = "https://lichess.org";

  final options = LichessOptions(
    lichessUrl: lichessUrl,
    connectionTimeout: const Duration(seconds: 1),
    userAgent: userAgent,
    tokenRefreshUrl: "https://test.test/api/lichess/refresh-token"
  );

  test('Lichess is initialized right', () {
    final lichess = Lichess(options);
    expect(lichess.options, options);
  });

  test('Parse complicated friends list', () {
    final friends = testFriends
          .replaceAll("\r\n", "\\r\\n")
          .split("\n")
          .where((element) => element.length > 1)
          .map((item) => LichessUser.parseJson(jsonDecode(item)))
          .toList();
    expect(friends.length, 52);
  });

  group("Lichess Authentication", () {

    test('Success', () async {
      const token = "token-123";
      final mockClient = MockHttpClient();
      final mockReq = FakeHttpClientRequest();
      final mockEventStreamReq = MockHttpClientRequest();
      final mockRes = MockHttpClientResponse();

      when(mockClient.getUrl(Uri.parse(lichessUrl + "/api/account"))).thenAnswer((_) => Future.value(mockReq));
      when(mockClient.getUrl(Uri.parse(lichessUrl + "/api/stream/event"))).thenAnswer((_) => Future.value(mockEventStreamReq));
      when(mockReq.close()).thenAnswer((_) => Future.value(mockRes));
      when(mockRes.statusCode).thenReturn(200);
      when(mockRes.transform<String>(any)).thenAnswer((_) => Stream.value(mockDataApiAccount));

      options.httpClient = mockClient;
      final lichess = Lichess(options);

      await lichess.authenticate(ChessPlatformCredentialsToken(token));
      expect(lichess.getState().user?.displayName, "Georges");
      expect(lichess.getState().user?.id, "georges");

      verify(mockReq.close()).called(1);
      verify(mockReq.headers.set('Authorization', "Bearer $token")).called(1);
      verify(mockReq.headers.set('User-Agent', userAgent)).called(1);
    });

    test('Fail', () async {
      const token = "token-123";
      final mockClient = MockHttpClient();
      final mockReq = FakeHttpClientRequest();
      final mockRes = MockHttpClientResponse();

      when(mockClient.getUrl(Uri.parse(lichessUrl + "/api/account"))).thenAnswer((_) => Future.value(mockReq));
      when(mockReq.close()).thenAnswer((_) => Future.value(mockRes));
      when(mockRes.statusCode).thenReturn(403);
      when(mockRes.transform<String>(any)).thenAnswer((_) => Stream.value(mockDataApiError));

      options.httpClient = mockClient;
      final lichess = Lichess(options);

      try {
          await lichess.authenticate(ChessPlatformCredentialsToken(token));
      } catch (e) {
          expect(e is ChessPlatformCredentialsInvalid, true);
      }

      expect(lichess.getState().user, null);
      verify(mockReq.headers.set('Authorization', "Bearer $token")).called(1);
      verify(mockReq.headers.set('User-Agent', userAgent)).called(1);
    });

  });
}