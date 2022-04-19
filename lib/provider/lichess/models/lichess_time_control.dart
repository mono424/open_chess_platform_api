class LichessTimeControl {
  late String type;
  late int limit;
  late int increment;
  late String show;

  LichessTimeControl({required this.type, required this.limit, required this.increment, required this.show});

  LichessTimeControl.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    limit = json['limit'];
    increment = json['increment'];
    show = json['show'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['limit'] = limit;
    data['increment'] = increment;
    data['show'] = show;
    return data;
  }
}