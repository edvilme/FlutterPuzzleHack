import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle/level.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';

int counter = 0;

Widget PatternsLevelEasy({
  Function? onNextLevel, 
  Function? onReset
}){
  List<String> patterns = ["Red", "Green", "Blue"];
  return Level(
    level: 4,
    key: Key("level-patterns-" + (counter++).toString()),
    shuffled: true,
    tileGenerator: (PuzzleTile t){
      t.type = patterns[Random().nextInt(patterns.length)];
    },
    tileDecorator: (PuzzleTileWidget w){
      w.child = null;
      if(w.data.type == 'Red') w.color = Colors.red[400]!;
      if(w.data.type == 'Green') w.color = Colors.green[400]!;
      if(w.data.type == 'Blue') w.color = Colors.blue[400]!;
    },
    onChange: (PuzzleTileMovementCallback callback, PuzzleBoard board){
      // Check row
      Set<String> rowPatterns = Set.from(
        callback.row.map((e) => e!.type)
      );
      // Check column
      Set<String> columnPatterns = Set.from(
        callback.column.map((e) => e!.type)
      );

/*       if(rowPatterns.length == 1){
        board.removeRow(callback.tile.position.i);
      } */

    },
    instructions: "Line up similar patterns",
    onNextLevel: (){
      onNextLevel!();
    },
    onReset: (){
      onReset!();
    },
  );
}