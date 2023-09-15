library open_chess_platform_api;

class LichessPerf {
  late String? icon;
  late String name;

  LichessPerf({this.icon, required this.name});

  LichessPerf.fromJson(Map<String, dynamic> json) {
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
