library chess_cloud_provider;

class LichessChallengParticipant {
  late String id;
  late String name;
  late String title;
  late int rating;
  late bool online;
  late int lag;

  LichessChallengParticipant({required this.id, required this.name, required this.title, required this.rating, required this.online, required this.lag});

  LichessChallengParticipant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    title = json['title'] ?? "";
    rating = json['rating'] ?? 1500;
    online = json['online'] ?? false;
    lag = json['lag'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['title'] = title;
    data['rating'] = rating;
    data['online'] = online;
    data['lag'] = lag;
    return data;
  }
}