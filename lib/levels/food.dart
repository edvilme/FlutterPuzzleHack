import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle/level.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';
import 'package:rive/rive.dart';

Widget MonsterTile(){
  return Container(
    margin: EdgeInsets.all(4),
    child: ClipOval(
      child: RiveAnimation.network('https://public.rive.app/community/runtime-files/623-1217-happy-monster.riv'),
    )
  );
}
Widget FoodTile(){
  return Container(
    // child: RiveAnimation.network('https://public.rive.app/community/runtime-files/238-457-ice-cream.riv'),
    child: RiveAnimation.network('https://public.rive.app/community/runtime-files/271-535-lollipop.riv'),
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
  int foodCount = Random().nextInt(18) + 2;
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
      w.color = Colors.transparent;
      // Food
      if(w.data.type == 'food'){
        w.child = FoodTile();
      } 
      if(w.data.type == 'poison'){
        w.child = PoisonTile();
      }
      if(w.data.type == 'tile'){
        w.color = Color.fromARGB(255, 196, 186, 186);
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
    instructions: "Help the character eat all the candy. Avoid the red squares.",
    onNextLevel: (){
      onNextLevel!();
    },
    onReset: (){
      onReset!();
    },
  );
}
