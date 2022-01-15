import 'dart:math';
import 'package:flutter/material.dart';
import 'package:puzzle/main.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';

class LevelWidget extends StatefulWidget{
  const LevelWidget({Key? key}) : super(key: key);

@override
LevelWidgetState createState() => LevelWidgetState();

}

class LevelWidgetState extends State<LevelWidget>{
  @override
  Widget build(BuildContext context){
    return PuzzleBoardWidget(
      shuffled: true,
      level: 4,
      onChange: (PuzzleTileMovementCallback callback, PuzzleBoard board){

      },
      tileGenerator: (PuzzleTile p){
        p.type = ['Red', 'Green', 'Blue', 'Orange'][Random().nextInt(4)];
      },
      tileDecorator: (PuzzleTileWidget w){
        w.child = Text(
          w.data.data, 
          style: const TextStyle(
            color: Colors.white, 
            decoration: TextDecoration.none
          ),
        );
        w.color = namedColors[w.data.type]!;
      },
    );
  }
}