import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';

class Level extends StatefulWidget{
  late int level;
  late bool? shuffled;
  late Function tileGenerator;
  late Function tileDecorator;

  late Function onChange;
  late Function? onNextLevel;
  late Function? onLoose;
  late Function? onScore;
  late Function? onPause;
  late Function? onReset;

  String instructions;

  Color backgroundColor;
  Color foregroundColor;

  Level({
    Key? key, 
    required this.level, 
    required this.shuffled,
    required this.onChange, 
    required this.tileDecorator, 
    required this.tileGenerator, 
    this.onLoose, 
    this.onScore, 
    this.onNextLevel, 
    this.onPause,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black87, 
    this.instructions = ""
  }) : super(key: key);

  @override
  LevelState createState() => LevelState();
}

class LevelState extends State<Level> {
  late PuzzleBoardWidget board;
  late String score;
  late String state;
  
  @override
  void initState() {
    super.initState();
    score = "0";
    state = "playing";
    board = PuzzleBoardWidget(
      level: widget.level, 
      shuffled: widget.shuffled,
      tileGenerator: widget.tileGenerator, 
      tileDecorator: widget.tileDecorator,
      onChange: (PuzzleTileMovementCallback c, PuzzleBoard p){
        setState(() {
          score = (p.moves++).toString();
        });
        String? result = widget.onChange(c, p);
        if(result == null) return;
        if(result == "win") board.win();
        if(result == "loose") board.win();
      },
      onWin: (){
        setState(() {
          state = "win";
        });
        
      },
      onLoose: (){
        setState(() {
          score = "You loose";
        });
        widget.onLoose!();
      },
    );
  }

  Widget buildPlaying(BuildContext context){
    return Container(
      color: widget.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 450,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  score,
                  style: TextStyle(
                    fontSize: 60, 
                    color: widget.foregroundColor, 
                    fontWeight: FontWeight.w300, 
                    decoration: TextDecoration.none
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      state = "paused";
                    });
                    if(widget.onPause != null) widget.onPause!();
                  },
                  child: Icon(
                    Icons.pause_circle_filled_sharp,
                    color: widget.foregroundColor, 
                    size: 50,
                  ),
                )
              ],
            ),
          ),
          board, 
          Container(
            width: 450,
            alignment: Alignment.center,
            child: Text(
              widget.instructions,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: widget.foregroundColor,
                fontWeight: FontWeight.w300, 
                fontSize: 24,
                decoration: TextDecoration.none
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildOverlay(BuildContext context){
    if(state == "paused"){
      return LevelPaused(
        onDismiss: (){
          setState(() {
            state = "playing";
          });
        },
        onReset: (){
          widget.onReset!();
        },
      );
    } else if (state == "win"){
      return LevelWin();
    } else if (state == "loose"){
      return LevelLoose();
    }
    return Container();
  }

  @override
  Widget build(BuildContext context){
    return Stack(
      fit: StackFit.expand,
      children: [
        buildPlaying(context), 
        buildOverlay(context)
      ],
    );
  }
}

class LevelPaused extends StatelessWidget{
  Function? onDismiss;
  Function? onReset;

  LevelPaused({
    Key? key,
    this.onDismiss,
    this.onReset
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        color: Colors.white54,
        alignment: Alignment.center,
        child: Container(
          width: 450,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: (){
                      onDismiss!();
                    },
                    child: const Icon(
                      Icons.play_circle_fill,
                      size: 80,
                      color: Colors.black,
                    ),
                  ), 
                  GestureDetector(
                    onTap: (){
                      onReset!();
                    },
                    child: const Icon(
                      Icons.replay_circle_filled_outlined, 
                      size: 80,
                      color: Colors.black,
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ),
    );
  }
}

class LevelWin extends StatelessWidget{
  Function? onNextLevel;
  LevelWin({
    Key? key, 
    this.onNextLevel
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        width: 450,
        color: Colors.white54, 
        child: Column(
          children: [
            Text(
              "You win!",
              style: TextStyle(
                color: Colors.black, 
                decoration: TextDecoration.none
              ),
            ), 
            GestureDetector(
              onTap: (){
                onNextLevel!();
              },
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.black,
              ),
            )
          ],
        ),
      )
    );
  }
}

class LevelLoose extends StatelessWidget{
  LevelLoose({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Text("You loose"),
    );
  }
}