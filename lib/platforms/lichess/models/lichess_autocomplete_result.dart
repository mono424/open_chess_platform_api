library open_chess_platform_api;

class LichessAutocompleteResult {
  late String userId;
  late String name;
  late String title;
  late bool patron;
  late bool online;

  LichessAutocompleteResult(
      {required this.userId,
      required this.name,
      required this.title,
      required this.patron,
      required this.online,
      });

  LichessAutocompleteResult.fromJson(Map<String, dynamic> json) {
    userId = (json['id'] != null && json['id'] is String) ? json['id'] : null;
    name = json['name'] ?? userId;
    title = json['title'] ?? "";
    online = json['patron'] ?? false;
    online = json['online'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = userId;
    data['name'] = name;
    data['title'] = title;
    data['patron'] = patron;
    data['online'] = online;
    return data;
  }

  @override
  bool operator ==(other) => other is LichessAutocompleteResult && other.userId == userId;

  @override
  int get hashCode => userId.hashCode;
}
