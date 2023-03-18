const initialCellValue = -3;
const mineCellValue = -2;
const emptyCellValue = -2;

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
}

class Coord {
  final int x;
  final int y;
  const Coord({required this.x, required this.y});

  bool operator ==(Object other) {
    return other is Coord && x == other.x && y == other.y;
  }

  @override
  int get hashCode => x * 23 + y;

  @override
  String toString() => '''
  Coord{x: $x, y: $y}
  ''';
}

class Game {
  const Game._(
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
      mineRatio: .4,
      firstMovePlayed: false,
    );
  }

  final List<List<Cell>> board;
  final int width;
  final int height;
  final double mineRatio;

  final bool firstMovePlayed;

  bool move(Coord coord) {
    assert(coord.x < 0 ||
        coord.y < 0 ||
        coord.x >= board.length ||
        coord.y >= board.first.length);
    if (!firstMovePlayed) {
      initializeBoard(coord);
      return true;
    }
    return false;
  }

  initializeBoard(Coord coord) {}

  Game copyWith(List<List<Cell>> board) {
    return Game._(
      board,
      width: width,
      height: height,
      mineRatio: mineRatio,
      firstMovePlayed: true,
    );
  }
}

/// Returns a list of [Coord]s surrounding the given [Coord] that contain a
/// [Cell.mine]. Provided [coord] must be in bounds.
List<Coord> numSurroundingMines(Coord coord, List<List<Cell>> board) {
  final coords = getSurroundngCoords(coord, board);

  return coords
      .where((coord) => board[coord.x][coord.y] == Cell.mine)
      .toList(growable: false);
}

/// Returns a list of [Coord]s surrounding the given [Coord] that are within the
/// bounds of  the given board. Provided [coord] must be in bounds.
List<Coord> getSurroundngCoords(Coord coord, List<List<Cell>> board) {
  final x = coord.x;
  final y = coord.y;

  assert(x >= 0 && y >= 0 && x < board.length && y < board.first.length);

  return [
    Coord(x: x - 1, y: y - 1),
    Coord(x: x - 1, y: y),
    Coord(x: x - 1, y: y + 1),
    Coord(x: x, y: y - 1),
    Coord(x: x, y: y + 1),
    Coord(x: x + 1, y: y - 1),
    Coord(x: x + 1, y: y),
    Coord(x: x + 1, y: y + 1),
  ]
      .where(
        (nextCoord) =>
            nextCoord.x >= 0 &&
            nextCoord.y >= 0 &&
            nextCoord.x < board.length &&
            nextCoord.y < board.first.length,
      )
      .toList(growable: false);
}
