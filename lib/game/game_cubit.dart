import 'dart:math' as math;
import 'package:bloc/bloc.dart';

import 'game.dart';

final _random = math.Random();

int fromRange(int min, int max) => min + _random.nextInt(max - min);

class GameCubit extends Cubit<Game> {
  GameCubit(Game Function() gameFactory) : super(gameFactory());

  void move(Point point) {
    assert(
      point.x >= 0 &&
          point.x < state.board.length &&
          point.y >= 0 &&
          point.y < state.board.first.length,
      'Point should be within the bounds of the board',
    );

    if (!state.firstMovePlayed) {
      emit(_initializeBoard(point));
      return;
    }

    _updateBoard(point);
  }

  Game _initializeBoard(Point point) {
    final nextBoard = state.boardCopy;
    int numMines = state.numMines;

    nextBoard[point.x][point.y] = Cell.emptySpace;

    final surroundingPoints = getSurroundngPoints(point, nextBoard);

    while (numMines > 0) {
      final nextX = fromRange(0, state.width);
      final nextY = fromRange(0, state.height);
      final nextPoint = Point(x: nextX, y: nextY);

      final pointInSurrounding = surroundingPoints.any(
        (surrounding) => surrounding == nextPoint,
      );
      if (!pointInSurrounding &&
          nextBoard[nextX][nextY].value == initialCellValue) {
        nextBoard[nextX][nextY] = Cell.mine;
        numMines--;
      }
    }

    final finalBoard = expand(point, nextBoard);

    return state.copyWith(finalBoard);
  }

  void _updateBoard(Point point) async {
    // (If tapped a mine, you've lost the game)
    var nextBoard = state.boardCopy;
    if (state.board[point.x][point.y] == Cell.mine) {
      // TODO: Show all mines
      assert(false);
    }
    final surroundingMines = numSurroundingMines(point, state.board);

    // If there are no surrounding mines, reveal edges in every direction.
    if (surroundingMines.isEmpty) {
      nextBoard = expand(point, nextBoard);
    } else {
      // There are now guaranteed surrounding mines. Paint [Point] with number of
      // surrounding mines.
      nextBoard[point.x][point.y] = Cell.surrounded(surroundingMines.length);
    }

    emit(state.copyWith(nextBoard));

    // Render board
    await Future.delayed(Duration.zero);

    //Check to see if game is won.
    //TODO: Check if game is won.
  }
}
