import 'package:flutter_test/flutter_test.dart';
import 'package:minesweeper/game/game.dart';

void main() {
  group('getSurroundngPoints', () {
    test('filters invalid Points', () {
      expect(
          getSurroundngPoints(const Point(x: 0, y: 0), [
            [Cell.initial, Cell.initial, Cell.initial],
            [Cell.initial, Cell.initial, Cell.initial],
            [Cell.initial, Cell.initial, Cell.initial],
          ]),
          [
            const Point(x: 0, y: 1),
            const Point(x: 1, y: 0),
            const Point(x: 1, y: 1),
          ]);
    });
  });
  group('numSurroundingMines', () {
    test('filters invalid Points', () {
      expect(
          numSurroundingMines(const Point(x: 0, y: 1), [
            [Cell.mine, Cell.initial, Cell.initial, Cell.initial],
            [Cell.mine, Cell.initial, Cell.mine, Cell.initial],
            [Cell.initial, Cell.mine, Cell.initial, Cell.initial],
            [Cell.initial, Cell.initial, Cell.initial, Cell.mine],
          ]),
          [
            const Point(x: 0, y: 0),
            const Point(x: 1, y: 0),
            const Point(x: 1, y: 2),
          ]);
    });
  });
}
