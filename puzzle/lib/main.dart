
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle/level.dart';
import 'package:puzzle/levels/image.dart';
import 'package:puzzle/levels/numbers.dart';
import 'package:puzzle/levels/patterns.dart';
import 'package:puzzle/levels/words.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';

void main(){
  runApp(
    MaterialApp(
      home: Container(
        color: Colors.amber,
        child: Game()
      )
    )
  );
}

class Game extends StatefulWidget{
  const Game({Key? key}) : super(key: key);
  @override
  GameState createState() => GameState();
}

class GameState extends State<Game>{
  // ignore: non_constant_identifier_names
  final List ALL_LEVELS = [
    NumberLevelEasy, 
    WordLevel,
    NumberLevelMedium,
    PatternsLevelEasy,
    ImageLevel
  ];

  late Widget currentLevel;
  late int currentLevelIndex;
  @override
  void initState() {
    super.initState();
    currentLevelIndex =  Random().nextInt(ALL_LEVELS.length);
    currentLevel = ALL_LEVELS[currentLevelIndex](
      onNextLevel: (){
        generateLevel(Random().nextInt(ALL_LEVELS.length));
      }, 
      onReset: (){
        generateLevel(currentLevelIndex);
      }
    );
  }

  void generateLevel(int index){
    setState(() {
      currentLevel = ALL_LEVELS[index](
        onNextLevel: (){
          generateLevel( Random().nextInt(ALL_LEVELS.length) );
        }, 
        onReset: (){
          generateLevel(index);
        }
      );
    });
  }
 

  @override
  Widget build(BuildContext context){
    return currentLevel;
  }
}