
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle/level.dart';
import 'package:puzzle/levels/numbers.dart';
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
  Game({Key? key}) : super(key: key);

  @override
  GameState createState() => GameState();
}

class GameState extends State<Game>{
  late Widget level;

  @override
  void initState() {
    super.initState();
    level = WordLevel(
      onNextLevel: (){
        nextLevel();
      }
    );
  }

  void nextLevel(){
    setState(() {
      level = NumberLevelEasy(
        onNextLevel: (){
          nextLevel();
        }
      );
    });
  }

  @override
  Widget build(BuildContext context){
    return level;
  }
}