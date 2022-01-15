
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';

PuzzleBoardWidget easy = PuzzleBoardWidget(
  shuffled: true,
  level: 4,
  tileGenerator: (PuzzleTile t){
    t.type = 'tile';
  },
  tileDecorator: (PuzzleTileWidget w){
    w.child = Text(
      w.data.data.toString(), 
      style: GoogleFonts.poiretOne(
        color: Colors.white, 
        decoration: TextDecoration.none,
        fontSize: w.size*0.5
      )
    );
  },
  onChange: (PuzzleTileMovementCallback callback, PuzzleBoard board){
    bool isIncorrect = board.getTiles().any((element) => element.position.i != element.correctPosition.i || element.position.j != element.correctPosition.j);
    if(!isIncorrect) easy.win();
  },
  onWin: (){},
);
void main() {
  runApp(
    MaterialApp(
      home: Center(
        widthFactor: 10,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              child: Text("12",
                style: GoogleFonts.poiretOne(
                  fontSize: 80, 
                  decoration: TextDecoration.none
                ),
              ),
            ),
            easy
          ],
        )
      )
    )
  );
}


