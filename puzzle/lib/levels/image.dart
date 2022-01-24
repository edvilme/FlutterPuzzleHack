import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:puzzle/level.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';
import 'package:http/http.dart' as http;

// Image.network("https://picsum.photos/200", width: 100, height: 100,)

int counter = 0;
Widget ImageLevel({
  Function? onNextLevel, 
  Function? onReset
}) {
  return Level(
    level: 3,
    key: Key("level-image-" + (counter++).toString()),
    shuffled: true,
    tileGenerator: (PuzzleTile t){
      t.type = 'tile';
    },
    tileDecorator: (PuzzleTileWidget w){
      w.child = Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black, 
            width: 1
          )
        ),
        child: FittedBox(
          fit: BoxFit.none,
          clipBehavior: Clip.antiAlias,
          alignment: Alignment(
            -1 + w.data.correctPosition.j.toDouble(),
            -1 + w.data.correctPosition.i.toDouble(),
          ),
          child: Image.network(
            "https://picsum.photos/300/300?a="+counter.toString(), 
            width: 300, 
            height: 300, 
            fit: BoxFit.cover,
          ),
        ),
      );
    },
    onChange: (PuzzleTileMovementCallback callback, PuzzleBoard board){
      bool isIncorrect = board.getTiles().any((element) => element.position.i != element.correctPosition.i || element.position.j != element.correctPosition.j);
      if(!isIncorrect) return "win";
    },
    onNextLevel: (){
      onNextLevel!();
    },
    onReset: (){
      onReset!();
    },
    instructions: "Sort the tiles to form the image",
  );
}