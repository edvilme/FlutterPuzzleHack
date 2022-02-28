import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';
import 'package:rive/rive.dart';

class Level extends StatefulWidget{
  late int level;
  late bool? shuffled;

  late bool Function(List<List<PuzzleTile?>>)? shuffleGenerator;

  late Function tileGenerator;
  late Function? emptyTileDecorator;
  late Function tileDecorator;

  late Function onChange;
  late Function? onScore;

  late Function? onLoose;
  late Function? onPause;
  
  late Function? onNextLevel;
  late Function? onReset;

  String instructions;

  Color backgroundColor;
  Color foregroundColor;

  Level({
    Key? key, 
    required this.level, 
    required this.shuffled,
    this.shuffleGenerator,
    required this.onChange, 
    required this.tileDecorator, 
    this.emptyTileDecorator,
    required this.tileGenerator, 
    // this.onLoose, 
    this.onReset,
    this.onScore, 
    this.onNextLevel, 
    this.onPause,
    this.backgroundColor = Colors.black,
    this.foregroundColor = Colors.white, 
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
    state = "playing";
    board = PuzzleBoardWidget(
      level: widget.level, 
      shuffled: widget.shuffled,
      shuffleGenerator: widget.shuffleGenerator,
      tileGenerator: widget.tileGenerator, 
      tileDecorator: widget.tileDecorator,
      emptyTileDecorator: widget.emptyTileDecorator,
      onChange: (PuzzleTileMovementCallback c, PuzzleBoard p){
        setState(() {
          score = (p.shuffledMoves - p.moveCount).toString();
        });
        String? result = widget.onChange(c, p);
        if(result == null) return;
        if(result == "win") board.win();
        if(result == "loose") board.loose();
      },
      onWin: (){
        setState(() {
          state = "win";
        });
        
      },
      onLoose: (){
        setState(() {
          state = "loose";
        });
        // widget.onLoose!();
      },
    );
    score = board.board.shuffledMoves.toString();
  }

  Widget buildPlaying(BuildContext context){
    return Container(
      color: widget.backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 300,
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
            width: 300,
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
      return LevelWin(
        onNextLevel: (){
          widget.onNextLevel!();
        },
      );
    } else if (state == "loose"){
      return LevelLoose(
        onReset: (){
          widget.onReset!();
        },
      );
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
                      size: 160,
                      color: Colors.black,
                    ),
                  ), 
                  GestureDetector(
                    onTap: (){
                      onReset!();
                    },
                    child: const Icon(
                      Icons.replay_circle_filled_outlined, 
                      size: 160,
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: const RiveAnimation.network("https://public.rive.app/community/runtime-files/2131-4192-coin.riv"),
              height: 450,
            ),
            const Text(
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
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                color: Colors.black,
                height: 40,
                width: 300,
                child: const Text(
                  "Next level", 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.none,
                    color: Colors.white, 
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}


class LevelLoose extends StatelessWidget{
  Function? onReset;
  LevelLoose({
    Key? key, 
    this.onReset
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
      child: Container(
        width: 450,
        color: Colors.white54, 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "You Loose!",
              style: TextStyle(
                color: Colors.black, 
                decoration: TextDecoration.none
              ),
            ), 
            GestureDetector(
              onTap: (){
                onReset!();
              },
              child: Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                color: Colors.black,
                height: 40,
                width: 300,
                child: const Text(
                  "Try again", 
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    decoration: TextDecoration.none,
                    color: Colors.white, 
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}
