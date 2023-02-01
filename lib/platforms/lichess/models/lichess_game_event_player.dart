library chess_cloud_provider;

class GameEventPlayer {
  late final String id;
  late final String? name;
  late final String? title;
  late final int? rating;
  late final bool? provisional;

  GameEventPlayer(
      {required this.id, this.name, this.title, this.rating, this.provisional});

  GameEventPlayer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    title = json['title'];
    rating = json['rating'];
    provisional = json['provisional'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['title'] = title;
    data['rating'] = rating;
    data['provisional'] = provisional;
    return data;
  }
}
