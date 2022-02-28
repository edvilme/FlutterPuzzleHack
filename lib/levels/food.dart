import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle/level.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';

Widget MonsterTile(){
  return Align(
    alignment: Alignment.center,
    child: Container(
      margin: EdgeInsets.all(16),
      color: Colors.amber,
    ),
  );
}

Widget FoodTile(){
  return Align(
    alignment: Alignment.center,
    child: Container(
      margin: EdgeInsets.all(16),
      color: Colors.white,
    ),
  );
}

Widget PoisonTile(){
  return Align(
    alignment: Alignment.center,
    child: Container(
      margin: EdgeInsets.all(16),
      color: Colors.red.shade900,
    ),
  );
}

int counter = 0;

Widget FoodLevel({
  Function? onNextLevel,
  Function? onReset,
}){
  int foodCount = Random().nextInt(20);
  int poisonCount = Random().nextInt(3);
  return Level(
    key: Key("food-number-" + (counter++).toString()),
    shuffled: true, 
    level: 5,
    tileGenerator: (PuzzleTile t){
      int count = t.correctPosition.i * 5 + t.correctPosition.j;
      if(count >= foodCount && count <= foodCount + poisonCount) t.type = 'poison';
      else if(count < foodCount) t.type = 'food';
      else t.type = 'tile';
    },
    emptyTileDecorator: (PuzzleTileWidget w){
      w.child = MonsterTile();
    },
    tileDecorator: (PuzzleTileWidget w){
      // Food
      if(w.data.type == 'food'){
        w.child = FoodTile();
      } 
      if(w.data.type == 'poison'){
        w.child = PoisonTile();
      }
      if(w.data.type == 'tile'){
        w.child = Container();
      }
    },
    onChange: (PuzzleTileMovementCallback callback, PuzzleBoard board){
      // Die on poisonous
      if(callback.tile.type == 'poison'){
        return "loose";
      }
      // Eat food
      if(callback.tile.type == 'food'){
        callback.tile.type = 'tile';
        foodCount--;
      }
      // Win when no food left
      if(foodCount == 0) return "win";
    },
    instructions: "Move the yellow tile to eat all the white tiles. Be careful to avoid red tiles",
    onNextLevel: (){
      onNextLevel!();
    },
    onReset: (){
      onReset!();
    },
  );
}
