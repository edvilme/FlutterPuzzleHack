import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:puzzle/level.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class GyroIndicator extends StatefulWidget{
  late double height;
  late double width;
  late Color color;
  late double rotation;

  late GyroIndicatorState state;

  GyroIndicator({
    Key? key, 
    this.height = 100,
    this.width = 100, 
    this.color = Colors.red, 
  }) : super(key: key);

  @override
  GyroIndicatorState createState() {
    state = GyroIndicatorState();
    return state;
  }
}

class GyroIndicatorState extends State<GyroIndicator>{
  double rotation = 0;

  void setRotation(_rotation){
    setState(() {
      rotation = _rotation;
    });
  }

  @override
  void initState(){
    super.initState();
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

class GyroLevelWidget extends StatefulWidget{
  late Function onNextLevel;
  late Function onReset;

  GyroLevelWidget({
    Key? key, 
    required this.onNextLevel, 
    required this.onReset
  }) : super(key: key);

  @override
  GyroLevelWidgetState createState() => GyroLevelWidgetState();
}

class GyroLevelWidgetState extends State<GyroLevelWidget>{
  double rotation = 0;
  late List<StreamSubscription<dynamic>> _streamSubscriptions = [];
  late List<GyroIndicator> gyroTiles = [];
  bool isMouseInsideTiles = false;

  @override
  void initState(){
    super.initState();
    if(defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.android){
      _streamSubscriptions.add(
        accelerometerEvents.listen((event) {
          setRotation(event.z > 8 || event.z < - 8 ? 0 : atan2(event.x, event.y));
        })
      );
    }
  }

  @override
  void dispose(){
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }

  void setRotation(double angle){
    // Round number
    double roundAngle = angle;
    // Update
    for (var element in gyroTiles) { 
      element.state.setRotation(roundAngle);
    }
  }

  @override
  Widget build(BuildContext context){
    return MouseRegion(
      onHover: (event) {
        if(isMouseInsideTiles) return;
        double x = event.position.dx - MediaQuery.of(context).size.width/2;
        double y = event.position.dy - MediaQuery.of(context).size.height/2;
        double distance = sqrt(x*x + y*y);
        if(distance < 250) return;
        setRotation(atan2(y, x));
      },
      child: Level(
        key: Key("level-gyro-1".toString()),
        level: 3,
        shuffled: true,
        tileGenerator: (PuzzleTile t){
          t.type = 'tile';
        },
        tileDecorator: (PuzzleTileWidget w){
          GyroIndicator gyro = GyroIndicator(width: 300, height: 300, color: Colors.amber);
          gyroTiles.add(gyro);
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
                child: gyro,
              ),
            );
        },
        onChange: (PuzzleTileMovementCallback callback, PuzzleBoard board){
          bool isIncorrect = board.getTiles().any((element) => element.position.i != element.correctPosition.i || element.position.j != element.correctPosition.j);
          if(!isIncorrect) return "win";
        },
        onNextLevel: (){
          widget.onNextLevel();
        },
        onReset: (){
          widget.onReset();
        },
        instructions: "Sort the tiles and rotate the phone or cursor to see the pattern",
      ),
    );
  }
}

Widget GyroLevel({
  Function? onNextLevel, 
  Function? onReset
}){
  return GyroLevelWidget(onNextLevel: onNextLevel!, onReset: onReset!);
}