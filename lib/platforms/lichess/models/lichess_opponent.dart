library chess_cloud_provider;

class LichessOpponent {
  late String id;
  late String username;
  late int rating;

  LichessOpponent(
      {required this.id, required this.username, required this.rating});

  LichessOpponent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['username'] = username;
    data['rating'] = rating;
    return data;
  }
}
