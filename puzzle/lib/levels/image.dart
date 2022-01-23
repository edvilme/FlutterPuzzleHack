import 'package:flutter/material.dart';
import 'package:puzzle/level.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';

Widget CroppedImage({
  required Image img, 
  required double cropHeight, 
  required double cropWidth,
  required double cropX, 
  required double cropY
}){
  return Container(
    height: cropHeight,
    width: cropWidth,
    child: FittedBox(
      fit: BoxFit.none,
      clipBehavior: Clip.hardEdge,
      alignment: Alignment(cropX, cropY),
      child: img,
    ),
  );
}

// Image.network("https://picsum.photos/200", width: 100, height: 100,)

int counter = 0;
Widget ImageLevel({
  Function? onNextLevel, 
  Function? onReset
}) {
  return Level(
    level: 4,
    key: Key("level-image-" + (counter++).toString()),
    shuffled: true,
    tileGenerator: (PuzzleTile t){
      t.type = 'tile';
    },
    tileDecorator: (PuzzleTileWidget w){
      w.child = CroppedImage(
        img: Image.network("https://picsum.photos/200", width: 300, height: 300,),
        cropHeight: w.size, 
        cropWidth: w.size, 
        cropX: w.data.correctPosition.i*300/w.size,
        cropY: w.data.correctPosition.j*300/w.size
      );
    },
    onChange: (PuzzleTileMovementCallback callback, PuzzleBoard board){

    },
  );
}