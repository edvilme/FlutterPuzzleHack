import 'dart:async';
import 'dart:math';
import 'package:puzzle/level.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroIndicator extends StatefulWidget{
  late double height;
  late double width;
  late Color color;
  GyroIndicator({
    Key? key, 
    this.height = 100,
    this.width = 100, 
    this.color = Colors.red
  }) : super(key: key);

  @override
  GyroIndicatorState createState() => GyroIndicatorState();
}

class GyroIndicatorState extends State<GyroIndicator>{
  late double rotation = 0;
  late List<StreamSubscription<dynamic>> _streamSubscriptions = [];
  @override
  void initState() {
    super.initState();
    _streamSubscriptions.add(
      accelerometerEvents.listen((event) {
        setState(() {
          if(event.z > 8 || event.z < -8) {
            rotation = 0.00;
          } else {
            rotation = double.parse(atan2(event.x, event.y).toStringAsFixed(2));
          }
        });
      })
    );
  }
  @override
  void dispose(){
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context){
    return Container(
      height: widget.height,
      width: widget.width,
      child: FittedBox(
        fit: BoxFit.none,
        clipBehavior: Clip.hardEdge,
        child: Transform.rotate(
          angle: rotation, 
          child: Container(
            height: sqrt(pow(widget.height, 2) + pow(widget.width, 2)),
            width: sqrt(pow(widget.height, 2) + pow(widget.width, 2)),
            child: Column(
              children: [
                Expanded(child: Container(),), 
                Expanded(child: Container(color: widget.color),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

int counter = 0;

Widget GyroLevel({
  Function? onNextLevel, 
  Function? onReset
}){
  return Level(
    key: Key("level-gyro-"+(counter++).toString()),
    level: 3,
    shuffled: true,
    tileGenerator: (PuzzleTile t){
      t.type = 'tile';
    },
    tileDecorator: (PuzzleTileWidget w){
      w.child = Container(
        height: 100,
        width: 100,
        child: FittedBox(
          fit: BoxFit.none,
          clipBehavior: Clip.antiAlias,
          alignment: Alignment(
            -1 + w.data.correctPosition.j.toDouble(), 
            -1 + w.data.correctPosition.i.toDouble()
          ),
          child: GyroIndicator(width: 300, height: 300, color: Colors.amber,),
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
    instructions: "Sort the tiles and rotate the phone to see the pattern",
  );
}