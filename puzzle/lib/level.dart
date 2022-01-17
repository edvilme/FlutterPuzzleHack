import 'package:flutter/material.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';

class LevelScreen extends StatefulWidget{
  late int level;
  late bool? shuffled;
  late Function tileGenerator;
  late Function tileDecorator;

  late Function onChange;
  late Function? onWin;
  late Function? onLoose;
  late Function? onScore;

  late Function? onPause;

  Color backgroundColor;
  Color foregroundColor;

  LevelScreen({
    Key? key, 
    required this.level, 
    required this.shuffled,
    required this.onChange, 
    required this.tileDecorator, 
    required this.tileGenerator, 
    this.onLoose, 
    this.onScore, 
    this.onWin, 
    this.onPause,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black87
  }) : super(key: key);

  @override
  LevelScreenState createState() => LevelScreenState();
}

class LevelScreenState extends State<LevelScreen> {
  late PuzzleBoardWidget board;
  late String score = "0";

  @override
  void initState() {
    super.initState();

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
          score = "You win";
        });
      },
      onLoose: (){
        setState(() {
          score = "You loose";
        });
      },
    );
  }

  @override
  Widget build(BuildContext context){
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
              "Sort the numbers in ascending order",
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
}