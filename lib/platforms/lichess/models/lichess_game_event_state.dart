library open_chess_platform_api;

class GameEventState {
  late final String type;
  late final String moves;
  late final int wtime;
  late final int btime;
  late final int winc;
  late final int binc;
  late final String status;
  late final bool wdraw;
  late final bool bdraw;
  late final bool wtakeback;
  late final bool btakeback;
  late final String? winner;

  GameEventState();

  GameEventState.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    moves = json['moves'];
    wtime = json['wtime'];
    btime = json['btime'];
    winc = json['winc'];
    binc = json['binc'];
    status = json['status'];
    bdraw = json['bdraw'] ?? false;
    wdraw = json['wdraw'] ?? false;
    wtakeback = json['wtakeback'] ?? false;
    btakeback = json['btakeback'] ?? false;
    winner = json['winner'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['moves'] = moves;
    data['wtime'] = wtime;
    data['btime'] = btime;
    data['winc'] = winc;
    data['binc'] = binc;
    data['status'] = status;
    data['bdraw'] = bdraw;
    data['wdraw'] = wdraw;
    data['wtakeback'] = wtakeback;
    data['btakeback'] = btakeback;
    if (winner != null) data['winner'] = winner;
    return data;
  }
}
