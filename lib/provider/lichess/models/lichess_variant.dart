class LichessVariant {
  late String key;
  late String name;
  late String short;

  LichessVariant({required this.key, required this.name, required this.short});

  LichessVariant.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    name = json['name'];
    short = json['short'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['key'] = key;
    data['name'] = name;
    data['short'] = short;
    return data;
  }
}