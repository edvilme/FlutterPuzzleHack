import 'package:flutter/material.dart';
import 'package:puzzle/level.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';


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
  /* return Column(
    children: [
      CroppedImage(
        img: Image.network("https://i.picsum.photos/id/1024/1920/1280.jpg?hmac=-PIpG7j_fRwN8Qtfnsc3M8-kC3yb0XYOBfVzlPSuVII", width: 300, height: 300,),
        cropHeight: 100, 
        cropWidth: 300, 
        cropX: 0,
        cropY: -1
      ),
      Divider(),
      CroppedImage(
        img: Image.network("https://i.picsum.photos/id/1024/1920/1280.jpg?hmac=-PIpG7j_fRwN8Qtfnsc3M8-kC3yb0XYOBfVzlPSuVII", width: 300, height: 300,),
        cropHeight: 100, 
        cropWidth: 300, 
        cropX: 0,
        cropY: 0
      ),
      Divider(),
      CroppedImage(
        img: Image.network("https://i.picsum.photos/id/1024/1920/1280.jpg?hmac=-PIpG7j_fRwN8Qtfnsc3M8-kC3yb0XYOBfVzlPSuVII", width: 300, height: 300,),
        cropHeight: 100, 
        cropWidth: 300, 
        cropX: 0,
        cropY: 1
      ),
    ]
  ); */
}