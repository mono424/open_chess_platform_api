library chess_cloud_provider;

class LichessChallengePerf {
  late String icon;
  late String name;

  LichessChallengePerf({required this.icon, required this.name});

  LichessChallengePerf.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['icon'] = icon;
    data['name'] = name;
    return data;
  }
}