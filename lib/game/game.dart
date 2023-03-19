const initialCellValue = -3;
const mineCellValue = -2;
const emptyCellValue = 0;

const smallBoardWidth = 5;
const smallBoardHeight = 5;

class Cell {
  final int _value;
  const Cell._(this._value);

  const Cell.surrounded(int surroundingMines)
      : assert(surroundingMines > 0 && surroundingMines < 9),
        _value = surroundingMines;

  static const initial = Cell._(initialCellValue);
  static const mine = Cell._(mineCellValue);
  static const emptySpace = Cell._(emptyCellValue);

  int get value => _value;

  bool operator <(Cell other) {
    return _value < other.value;
  }

  bool operator >(Cell other) {
    return _value > other.value;
  }

  @override
  bool operator ==(Object other) {
    if (other is Cell) return _value == other.value;
    return other is Cell && _value == other.value;
  }

  @override
  int get hashCode {
    return _value.hashCode;
  }

  @override
  String toString() => 'Cell: $value';
}

class Point {
  final int x;
  final int y;
  const Point({required this.x, required this.y});

  @override
  bool operator ==(Object other) {
    return other is Point && x == other.x && y == other.y;
  }

  @override
  int get hashCode => x * 23 + y;

  @override
  String toString() => '''
  Point{x: $x, y: $y}
  ''';
}

class Game {
  Game._(
    this.board, {
    required this.mineRatio,
    required this.width,
    required this.height,
    required this.firstMovePlayed,
  })  : assert(
          width > 3 && height > 3,
          'The width and height must be greater than 3',
        ),
        assert(mineRatio > 0 && mineRatio < 1);

  factory Game.small() {
    return Game._(
      List.generate(
        smallBoardWidth,
        (_) => List.generate(
          smallBoardHeight,
          (_) => Cell.initial,
        ),
      ),
      width: smallBoardWidth,
      height: smallBoardHeight,
      mineRatio: .1,
      firstMovePlayed: false,
    );
  }

  final List<List<Cell>> board;
  final int width;
  final int height;
  final double mineRatio;

  final bool firstMovePlayed;

  int get numMines => (width * height * mineRatio).floor();

  Game copyWith(List<List<Cell>> board) {
    return Game._(
      board,
      width: width,
      height: height,
      mineRatio: mineRatio,
      firstMovePlayed: true,
    );
  }

  /// Deep copies the board. Expensive, use only to obtain a new reference for
  /// updating state.
  List<List<Cell>> get boardCopy =>
      board.map((e) => e.map((c) => c).toList()).toList();

  @override
  String toString() => '''
    Game {
      board: [
        ${board.string()}
      ],
      width: $width
      height: $height
      mineRatio: $mineRatio
      numMines: $numMines
      firstMovePlayed: $firstMovePlayed
    }
  ''';
}

extension BoardPrint on List<List<Cell>> {
  String string() => this
      .expand(
          (row) => [...row.map((cell) => cell.toString())..join('< | >'), '\n'])
      .join();
}

/// Returns a list of [Point]s surrounding the given [Point] that contain a
/// [Cell.mine]. Provided [point] must be in bounds.
List<Point> numSurroundingMines(Point point, List<List<Cell>> board) {
  final points = getSurroundngPoints(point, board);

  return points
      .where((nextPoint) => board[nextPoint.x][nextPoint.y] == Cell.mine)
      .toList(growable: false);
}

/// Returns a list of [Point]s surrounding the given [Point] that are within the
/// bounds of  the given board. Provided [point] must be in bounds.
List<Point> getSurroundngPoints(Point point, List<List<Cell>> board) {
  final x = point.x;
  final y = point.y;

  assert(x >= 0 && y >= 0 && x < board.length && y < board.first.length);

  return [
    Point(x: x - 1, y: y - 1),
    Point(x: x - 1, y: y),
    Point(x: x - 1, y: y + 1),
    Point(x: x, y: y - 1),
    Point(x: x, y: y + 1),
    Point(x: x + 1, y: y - 1),
    Point(x: x + 1, y: y),
    Point(x: x + 1, y: y + 1),
  ]
      .where(
        (nextPoint) =>
            nextPoint.x >= 0 &&
            nextPoint.y >= 0 &&
            nextPoint.x < board.length &&
            nextPoint.y < board.first.length,
      )
      .toList(growable: false);
}

/// Modifies given board by expanding from a given coord until all provided
/// points that have been reached touch a mine.
List<List<Cell>> expand(Point startingPoint, List<List<Cell>> board) {
  return _expand(startingPoint, board, {});
}

List<List<Cell>> _expand(
  Point point,
  List<List<Cell>> board,
  Set<Point> visited,
) {
  if (visited.contains(point)) return board;
  visited.add(point);

  final mines = numSurroundingMines(point, board);

  if (mines.isNotEmpty) {
    board[point.x][point.y] = Cell.surrounded(mines.length);
    return board;
  }

  board[point.x][point.y] = Cell.emptySpace;
  var nextBoard = board;
  for (final nextPoint in getSurroundngPoints(point, board)) {
    nextBoard = _expand(nextPoint, nextBoard, visited);
  }
  return nextBoard;
}
