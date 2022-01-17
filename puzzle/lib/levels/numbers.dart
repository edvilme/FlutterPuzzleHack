import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle/level.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';

Widget NumberLevelEasy(){
  return Level(
    shuffled: true, 
    level: 3,
    tileGenerator: (PuzzleTile t){
      t.type = 'tile';
    },
    tileDecorator: (PuzzleTileWidget w){
      w.child = Text(
        w.data.data.toString(), 
        style: GoogleFonts.poiretOne(
          color: Colors.white, 
          decoration: TextDecoration.none, 
          fontSize: w.size * 0.5
        ),
      );
    },
    onChange: (PuzzleTileMovementCallback callback, PuzzleBoard board){
      bool isIncorrect = board.getTiles().any((element) => element.position.i != element.correctPosition.i || element.position.j != element.correctPosition.j);
      if(!isIncorrect) return "win";
    },
    instructions: "Sort the numbers in order",
  );
}