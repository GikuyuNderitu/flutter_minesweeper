import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minesweeper/game/game.dart';
import 'package:minesweeper/game/game_cubit.dart';
import 'package:quiver/iterables.dart';

class GameView extends StatelessWidget {
  const GameView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<GameCubit, Game, List<List<Cell>>>(
      selector: (state) => state.board,
      builder: (context, state) {
        return GridView.count(
          childAspectRatio: 2,
          crossAxisCount: state.first.length,
          children: [
            for (final indexedRow in enumerate(state))
              for (final indexedCell in enumerate(indexedRow.value))
                CellView(
                  cell: indexedCell.value,
                  point: Point(x: indexedRow.index, y: indexedCell.index),
                ),
          ],
        );
      },
    );
  }
}

class CellView extends StatelessWidget {
  const CellView({super.key, required this.cell, required this.point});

  final Cell cell;
  final Point point;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.read<GameCubit>().move(point),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, strokeAlign: 2.0),
            color: _cellToColor(cell),
          ),
          padding: const EdgeInsets.all(58.0),
          child: Center(
            child: Text(
              number,
              style: textTheme.headlineLarge?.copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );
  }

  Color get textColor {
    switch (cell.value) {
      case initialCellValue:
      case mineCellValue:
      case emptyCellValue:
        return Colors.transparent;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      case 4:
        return Colors.deepPurple;
      case 5:
        return Colors.brown;
      case 6:
        return Colors.yellow;
      case 7:
        return Colors.purple;
      case 8:
        return Colors.orange;
    }

    throw ArgumentError('Unexpected Cell value');
  }

  String get number {
    switch (cell.value) {
      case initialCellValue:
      case mineCellValue:
      case emptyCellValue:
        return '';
      default:
        return cell.value.toString();
    }
  }
}

Color _cellToColor(Cell cell) {
  switch (cell.value) {
    case initialCellValue:
    case mineCellValue:
      return Colors.grey;
    case emptyCellValue:
    default:
      return const Color.fromARGB(255, 212, 190, 182);
  }
}
