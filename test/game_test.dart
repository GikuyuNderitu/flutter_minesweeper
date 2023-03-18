import 'package:flutter_test/flutter_test.dart';
import 'package:minesweeper/game/game.dart';

void main() {
  group('getSurroundngCoords', () {
    test('filters invalid Coords', () {
      expect(
          getSurroundngCoords(const Coord(x: 0, y: 0), [
            [Cell.initial, Cell.initial, Cell.initial],
            [Cell.initial, Cell.initial, Cell.initial],
            [Cell.initial, Cell.initial, Cell.initial],
          ]),
          [
            const Coord(x: 0, y: 1),
            const Coord(x: 1, y: 0),
            const Coord(x: 1, y: 1),
          ]);
    });
  });
  group('numSurroundingMines', () {
    test('filters invalid Coords', () {
      expect(
          numSurroundingMines(const Coord(x: 0, y: 1), [
            [Cell.mine, Cell.initial, Cell.initial, Cell.initial],
            [Cell.mine, Cell.initial, Cell.mine, Cell.initial],
            [Cell.initial, Cell.mine, Cell.initial, Cell.initial],
            [Cell.initial, Cell.initial, Cell.initial, Cell.mine],
          ]),
          [
            const Coord(x: 0, y: 0),
            const Coord(x: 1, y: 0),
            const Coord(x: 1, y: 2),
          ]);
    });
  });
}
