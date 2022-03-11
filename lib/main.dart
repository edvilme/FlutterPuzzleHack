/**
 * Submission for #FlutterPuzzleHack
 * Dedicated to Ana, for all her extraordinary support in this process. 
 * For helping me test early builds, proposing ideas and encouraging me
 * to contiunue development. 
 * 
 * Made with ❤️ by @edvilme.
 */
import 'dart:math';
import 'dart:io' as IO;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/io_client.dart';
import 'package:puzzle/level.dart';
import 'package:puzzle/levels/food.dart';
import 'package:puzzle/levels/gyro.dart';
import 'package:puzzle/levels/image.dart';

import 'package:puzzle/levels/numbers.dart';
import 'package:puzzle/levels/patterns.dart';
import 'package:puzzle/levels/tictactoe.dart';
import 'package:puzzle/levels/words.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';

void main(){
  runApp(
    MaterialApp(
      title: "!Puzzle",
      debugShowCheckedModeBanner: false,
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
    ImageLevel,
    GyroLevel,
    TicTacToeLevel,
    FoodLevel
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