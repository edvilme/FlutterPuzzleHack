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
  late Function tileGenerator;
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
    this.onChange,
    this.onWin, 
    this.onLoose, 
    this.onScore,
    this.shuffled,
  }) : super(key: key) {
    board = PuzzleBoard(level, tileGenerator);
    if(shuffled == true) board.shuffle(10*level*level);
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
  // List<PuzzleTile> tileModels = [];

  List<Widget> tileWidgets = [];

  @override
  void initState() {
    super.initState();
    update();
  }

  void moveToPosition(int i, int j){
    widget.board.moveToPosition(i, j, (PuzzleTileMovementCallback callback){
      if(widget.onChange == null) return;
      widget.onChange!(callback, widget.board);
      update();
    });
  }

  void update(){
    setState(() {  
      tileWidgets = widget.board.getTiles().map((tile){
        AnimatedPositioned tileWidget = AnimatedPositioned(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOutBack,
          key: Key(tile.getID().toString()),
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
        ...tileWidgets
      ],
    );
  }

}
