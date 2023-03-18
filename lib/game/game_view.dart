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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.read<GameCubit>().move(point),
        child: Padding(
          padding: const EdgeInsets.all(58.0),
          child: Text(cell.value.toString()),
        ),
      ),
    );
  }
}
