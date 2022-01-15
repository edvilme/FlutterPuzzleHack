import 'package:flutter/material.dart';
import 'package:puzzle/puzzlemodel.dart';

class PuzzleTileWidget extends StatelessWidget{

  late PuzzleTile data;
  late Widget? child;
  final double size;
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
      child: Container(
        height: size - 8,
        width: size - 8,
        color: color,
        child: child,
        margin: const EdgeInsets.all(4),
        alignment: Alignment.center,
      ),
    );
  }
}

class PuzzleBoardWidget extends StatefulWidget{
  late double size;
  late int level;
  late PuzzleBoard board;
  late Function onChange;
  late bool? shuffled;
  late Function tileGenerator;
  late Function tileDecorator;
  PuzzleBoardWidget({
    Key? key, 
    this.size = 500, 
    required this.level, 
    required this.onChange,
    required this.tileGenerator, 
    required this.tileDecorator,
    this.shuffled,
  }) : super(key: key) {
    board = PuzzleBoard(level, tileGenerator);
    if(shuffled == true) board.shuffle(10*level*level);
  }

  @override
  PuzzleBoardWidgetState createState() => PuzzleBoardWidgetState();

}


class PuzzleBoardWidgetState extends State<PuzzleBoardWidget>{
  List<Widget> tiles = [];

  @override
  void initState() {
    super.initState();
    update();
  }

  void moveToPosition(int i, int j){
    widget.board.moveToPosition(i, j, (PuzzleTileMovementCallback callback){
      widget.onChange(callback, widget.board);
      update();
    });
  }

  void update(){
    setState(() {  
      tiles = widget.board.getTiles().map((tile){
        Positioned tileWidget = Positioned(
          // key: Key(tile.getID().toString()),
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
        return tileWidget;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context){
    return Stack(
      children: [
        Container(width: widget.size, height: widget.size),
        ...tiles
      ],
    );
  }

}
