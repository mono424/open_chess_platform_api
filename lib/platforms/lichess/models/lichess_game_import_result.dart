library open_chess_platform_api;

class LichessGameImportResult {
  late String id;
  late String url;

  LichessGameImportResult({required this.id, required this.url});

  LichessGameImportResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['url'] = url;
    return data;
  }
}
