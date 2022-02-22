import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle/level.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';

int counter = 0;

bool ticTacToeWinner(List<List<PuzzleTile?>> tiles){
  // Check by rows
    for(int i = 0; i < 3; i++){
      if(tiles[i][0]!.data == tiles[i][1]!.data && tiles[i][1]!.data == tiles[i][2]!.data) return true;
    }
    // Check by cols
    for(int i = 0; i < 3; i++){
      if(tiles[0][i]!.data == tiles[1][i]!.data && tiles[1][i]!.data == tiles[2][i]!.data) return true;
    }
    // Check by diagonal
    if(tiles[0][0]!.data == tiles[1][1]!.data && tiles[1][1]!.data == tiles[2][2]!.data) return true;
    if(tiles[0][2]!.data == tiles[1][1]!.data && tiles[1][1]!.data == tiles[2][0]!.data) return true;
    return false;
}

Widget TicTacToeLevel({
  Function? onNextLevel,
  Function? onReset,
}){
  return Level(
    key: Key("level-number-" + (counter++).toString()),
    shuffled: true, 
    shuffleGenerator: (tiles){
      return !ticTacToeWinner(tiles);
    },
    level: 3,
    tileGenerator: (PuzzleTile t){
      t.type = 'tile';
      t.data = t.getID() < 4 ? 'O' : 'X';
    },
    tileDecorator: (PuzzleTileWidget w){
      w.color = w.data.getID() < 4 ? Colors.orange : Colors.purple;
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
      if(ticTacToeWinner(board.tiles)) return "win";
    },
    instructions: "Move the tiles to win the tic tac toe game",
    onNextLevel: (){
      onNextLevel!();
    },
    onReset: (){
      onReset!();
    },
  );
}