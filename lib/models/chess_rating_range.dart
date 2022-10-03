class ChessRatingRange {
  final int from;
  final int to;

  ChessRatingRange(this.from, this.to);

  ChessRatingRange.fromList(List<int> list)
      : from = list[0],
        to = list[1];
}
