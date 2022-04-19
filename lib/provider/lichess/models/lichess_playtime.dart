class LichessPlayTime {
  late int total;
  late int tv;

  LichessPlayTime({required this.total, required this.tv});

  LichessPlayTime.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    tv = json['tv'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['total'] = total;
    data['tv'] = tv;
    return data;
  }
}