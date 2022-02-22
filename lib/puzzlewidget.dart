import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:puzzle/puzzlemodel.dart';

class PuzzleTileWidget extends StatelessWidget{

  late PuzzleTile data;
  late Widget? child;
  late double size;
  late Color color;
  final Function onTap;

  PuzzleTileWidget({
    Key? key, 
    required this.size,
    required this.onTap,
    required this.data,
    this.child = const Text('*'), 
    this.color = Colors.transparent, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: (){
        onTap();
      },
      onHorizontalDragEnd: (details){
        onTap();
      },
      onVerticalDragEnd: (details){
        onTap();
      },
      child: Container(
        height: size - 4,
        width: size - 4,
        color: color,
        child: child,
        alignment: Alignment.center
      ),
    );
  }
}

class PuzzleBoardWidget extends StatefulWidget{
  late PuzzleBoard board;

  late double size;
  late int level;
  late bool? shuffled;
  late bool Function(List<List<PuzzleTile?>>)? shuffleGenerator;
  late Function tileGenerator;
  late Function? emptyTileDecorator;
  late Function tileDecorator;

  late Function? onChange;
  late Function? onWin;
  late Function? onLoose;
  late Function? onScore;

  PuzzleBoardWidget({
    Key? key, 
    this.size = 300, 
    required this.level, 
    required this.tileGenerator, 
    required this.tileDecorator,
    this.emptyTileDecorator,
    this.shuffleGenerator, 
    this.onChange,
    this.onWin, 
    this.onLoose, 
    this.onScore,
    this.shuffled,
  }) : super(key: key) {
    board = PuzzleBoard(size: level, tileGenerator: tileGenerator);
    if(shuffled == true) board.shuffle(10*level*level, shuffleGenerator);
  }
  @override
  PuzzleBoardWidgetState createState() => PuzzleBoardWidgetState();

  void win(){
    board.win(onWin);
  }
  void loose(){
    board.loose(onLoose);
  }
  void score(){
    board.score(onScore);
  }
}


class PuzzleBoardWidgetState extends State<PuzzleBoardWidget>{

  List<Widget> tileWidgets = [];

  @override
  void initState() {
    super.initState();
    update();
  }

  void moveToPosition(int i, int j){
    if(i < 0 || j < 0 || i >= widget.board.size || j>= widget.board.size) return;
    widget.board.moveToPosition(i, j, (PuzzleTileMovementCallback callback){
      if(widget.onChange == null) return;
      HapticFeedback.selectionClick();
      widget.onChange!(callback, widget.board);
      update();
    });
  }

  void moveInDirection(String direction){
    //for(int i = 0; i < widget.level - 1; i++){
      widget.board.moveInDirection(direction, (PuzzleTileMovementCallback callback){
        if(widget.onChange == null) return;
        HapticFeedback.selectionClick();
        widget.onChange!(callback, widget.board);
        update();
      });
    //}
  }

  void update(){
    setState(() {  
      tileWidgets = widget.board.getTiles().map((tile){
        AnimatedPositioned tileWidget = AnimatedPositioned(
          duration: Duration(milliseconds: 100 + 50 * (widget.level - tile.position.i) + 50 * tile.position.j),
          curve: Curves.easeInOutBack,
          key: Key("tile-" + tile.getID().toString()),
          top: widget.size * tile.position.i / widget.board.size,
          left: widget.size * tile.position.j / widget.board.size,
          child: PuzzleTileWidget(
            data: tile,
            child: Text(tile.data, style: const TextStyle(decoration: TextDecoration.none),),
            size: widget.size / widget.board.size,
            color: tile.type == 'empty' ? Colors.transparent : Colors.black,
            onTap: (){
              moveToPosition(tile.position.i, tile.position.j);
            },
          ),
        );
        if(tile.type != 'empty') widget.tileDecorator(tileWidget.child);
        if(tile.type == 'empty') widget.emptyTileDecorator?.call(tileWidget.child);
        return tileWidget;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context){
    return RawKeyboardListener(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (e){
        if(e.isKeyPressed(LogicalKeyboardKey.arrowUp)) return moveInDirection("down");
        if(e.isKeyPressed(LogicalKeyboardKey.arrowDown)) return moveInDirection("up");
        if(e.isKeyPressed(LogicalKeyboardKey.arrowLeft)) return moveInDirection("right");
        if(e.isKeyPressed(LogicalKeyboardKey.arrowRight)) return moveInDirection("left");
      },
      child: Stack(
        children: [
          Container(width: widget.size, height: widget.size),
          ...tileWidgets
        ],
      ),
    );
  }
}
