import 'dart:math' as math;
import 'package:bloc/bloc.dart';

import 'game.dart';

final _random = math.Random();

int fromRange(int min, int max) => min + _random.nextInt(max - min);

class GameCubit extends Cubit<Game> {
  GameCubit(Game Function() gameFactory) : super(gameFactory());

  void move(Point point) {
    // TODO: Boundary check point.
    if (!state.firstMovePlayed) {
      emit(_initializeBoard(point));
      return;
    }

    emit(_updateBoard(point));
  }

  @override
  void onChange(Change<Game> change) {
    print('Current State: \n ${change.currentState}');
    super.onChange(change);
    print('Next State: \n ${change.nextState}');
  }

  Game _initializeBoard(Point point) {
    final nextBoard = state.board.map((e) => e.map((c) => c).toList()).toList();
    int numMines = (state.width * state.height * state.mineRatio).floor();

    print(numMines);

    nextBoard[point.x][point.y] = Cell.emptySpace;

    final pointsToZero = getSurroundngPoints(point, nextBoard);

    while (numMines > 0) {
      final nextX = fromRange(0, state.width);
      final nextY = fromRange(0, state.height);

      /// TODO: Add boundary logic for not letting [point] or any of the cells
      /// TODO: that surround [point] to be a mine.
      print('Next X: $nextX');
      print('Next Y: $nextY');
      if (nextBoard[nextX][nextY].value == initialCellValue) {
        nextBoard[nextY][nextY] = Cell.mine;
        numMines--;
      }
    }
    return state.copyWith(nextBoard);
  }

  Game _updateBoard(Point point) {
    // (If tapped a mine, you've lost the game)
    final nextBoard = state.board;
    if (state.board[point.x][point.y] == Cell.mine) {
      // TODO: Show all mines
      assert(false);
      return state;
    }
    final surroundingMines = numSurroundingMines(point, state.board);

    // If there are no surrounding mines, reveal edges in every direction.
    if (surroundingMines.isEmpty) {
      // TODO: Reveal mine edges.
      assert(false);
      return state;
    }

    // There are now guaranteed surrounding mines. Paint [Point] with number of
    // surrounding mines.
    nextBoard[point.x][point.y] = Cell.surrounded(surroundingMines.length);

    return state.copyWith(nextBoard);
  }
}
