library chess_cloud_provider;

class LichessCount {
  late int all;
  late int rated;
  late int ai;
  late int draw;
  late int drawH;
  late int loss;
  late int lossH;
  late int win;
  late int winH;
  late int bookmark;
  late int playing;
  late int import;
  late int me;

  LichessCount(
      {required this.all,
      required this.rated,
      required this.ai,
      required this.draw,
      required this.drawH,
      required this.loss,
      required this.lossH,
      required this.win,
      required this.winH,
      required this.bookmark,
      required this.playing,
      required this.import,
      required this.me});

  LichessCount.fromJson(Map<String, dynamic> json) {
    all = json['all'];
    rated = json['rated'];
    ai = json['ai'];
    draw = json['draw'];
    drawH = json['drawH'];
    loss = json['loss'];
    lossH = json['lossH'];
    win = json['win'];
    winH = json['winH'];
    bookmark = json['bookmark'];
    playing = json['playing'];
    import = json['import'];
    me = json['me'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['all'] = all;
    data['rated'] = rated;
    data['ai'] = ai;
    data['draw'] = draw;
    data['drawH'] = drawH;
    data['loss'] = loss;
    data['lossH'] = lossH;
    data['win'] = win;
    data['winH'] = winH;
    data['bookmark'] = bookmark;
    data['playing'] = playing;
    data['import'] = import;
    data['me'] = me;
    return data;
  }
}
