library open_chess_platform_api;

class LichessClock {
  late final int initial;
  late final int increment;

  LichessClock(this.initial, this.increment);

  LichessClock.fromJson(Map<String, dynamic> json) {
    initial = json['initial'];
    increment = json['increment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['initial'] = initial;
    data['increment'] = increment;
    return data;
  }
}
