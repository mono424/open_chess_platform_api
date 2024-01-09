library open_chess_platform_api;

class TimeOption {
  final Duration time;
  final Duration increment;

  TimeOption(this.time, this.increment);

  bool get isNoTime => time == Duration.zero && increment == Duration.zero;

  static TimeOption noTime() {
    return TimeOption(Duration.zero, Duration.zero);
  }
}
