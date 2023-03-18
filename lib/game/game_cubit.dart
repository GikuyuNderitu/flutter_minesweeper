import 'dart:math' as math;
import 'package:bloc/bloc.dart';

import 'game.dart';

final _random = math.Random();

int fromRange(int min, int max) => min + _random.nextInt(max - min);

class GameCubit extends Cubit<Game> {
  GameCubit(Game Function() gameFactory) : super(gameFactory());

  move(Coord coord) {
    // TODO: Boundary check coord.
    if (!state.firstMovePlayed) {
      emit(_initializeBoard(coord));
      return;
    }

    emit(_updateBoard(coord));
  }

  Game _initializeBoard(Coord coord) {
    final nextBoard = state.board.sublist(0);
    int numMines = (state.width * state.height * state.mineRatio).floor();

    while (numMines > 0) {
      final nextX = fromRange(0, state.width);
      final nextY = fromRange(0, state.height);

      /// TODO: Add boundary logic for not letting [coord] or any of the cells
      /// TODO: that surround [coord] to be a mine.
      if (nextBoard[nextX][nextY].value == initialCellValue) {
        nextBoard[nextY][nextY] == Cell.mine;
        numMines--;
      }
    }
    return state.copyWith(nextBoard);
  }

  Game _updateBoard(Coord coord) {
    // (If tapped a mine, you've lost the game)
    final nextBoard = state.board;
    if (state.board[coord.x][coord.y] == Cell.mine) {
      // TODO: Show all mines
      assert(false);
      return state;
    }
    final surroundingMines = numSurroundingMines(coord, state.board);

    // If there are no surrounding mines, reveal edges in every direction.
    if (surroundingMines.isEmpty) {
      // TODO: Reveal mine edges.
      assert(false);
      return state;
    }

    // There are now guaranteed surrounding mines. Paint Coord with number of
    // surrounding mines.
    nextBoard[coord.x][coord.y] = Cell.surrounded(surroundingMines.length);

    return state.copyWith(nextBoard);
  }
}
