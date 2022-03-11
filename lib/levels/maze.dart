import 'dart:math';

import 'package:flutter/material.dart';

class Maze_LinePoint{
  final int i;
  final int j;
  const Maze_LinePoint({
    required this.i, 
    required this.j
  });
}

class Maze_LineSegment{
  final Maze_LinePoint start;
  final Maze_LinePoint end;
  const Maze_LineSegment({
    required this.start, 
    required this.end
  });
}

class Maze_GraphNode{
  final int i;
  final int j;
  const Maze_GraphNode({
    required this.i, 
    required this.j
  });
  Maze_LinePoint toLinePoint(){
    return Maze_LinePoint(i: i, j: j);
  }
}

class Maze_GraphEdge{
  final int u;
  final int v;
  final int w;
  const Maze_GraphEdge({
    required this.u, 
    required this.v, 
    required this.w
  });
}

class Maze_Graph{
  final List<Maze_GraphNode> nodes;
  final List<Maze_GraphEdge> edges;
  const Maze_Graph({
    required this.nodes, 
    required this.edges
  });
  void addEdge(int u, int v, int w){
    edges.add(Maze_GraphEdge(u: u, v: v, w: w));
  }
  int search(List<int> parent, int i){
    if(parent[i] == i) return i;
    return search(parent, parent[i]);
  }
  void apply_union(List<int> parent, List<int> rank, int x, int y){
    int x_root = search(parent, x);
    int y_root = search(parent, y);
    if(rank[x_root] < rank[y_root]){
      parent[x_root] = y_root;
    } else if(rank[x_root] > rank[y_root]){
      parent[y_root] = x_root;
    } else {
      parent[y_root] = x_root;
      rank[x_root]++;
    }
  }
  List<Maze_GraphEdge> kruskal(){
    List<Maze_GraphEdge> result = [];
    int i = 0;
    int e = 0;
    // Sort edges
    edges.sort((a, b) => a.w - b.w);
    // Init parent and rank
    List<int> parent = [];
    List<int> rank = [];
    for(int _i = 0; _i < nodes.length; _i++){
      parent.add(_i);
      rank.add(0);
    }
    while(e < nodes.length - 1){
      Maze_GraphEdge edge = edges[i];
      i++;
      int x = search(parent, edge.u);
      int y = search(parent, edge.v);
      if(x!=y){
        e++;
        result.add(edge);
        apply_union(parent, rank, x, y);
      }
    }
    return result;
  }
}

List<Maze_LineSegment> generateMaze(int n){
  // Generate graph
  List<Maze_GraphNode> nodes = [];
  for(int i = 0; i < n; i++){
    for(int j = 0; j < n; j++){
      nodes.add(Maze_GraphNode(i: i, j: j));
    }
  }
  Maze_Graph graph = Maze_Graph(nodes: nodes, edges: []);
  // Edges
  for(int i = 0; i < graph.nodes.length; i++){
    Maze_GraphNode node = graph.nodes[i];
    // Top (-n)
    int topIndex = i - n;
    if(topIndex >= 0 && graph.nodes[topIndex].i < node.i){
      graph.addEdge(i, topIndex, Random().nextInt(10) + 1);
    }
    // Right (+1)
    int rightIndex = i + 1;
    if(rightIndex < graph.nodes.length - 1 && graph.nodes[rightIndex].j > node.j){
      graph.addEdge(i, rightIndex, Random().nextInt(10) + 1);
    }
    // Bottom (+n)
    int bottomIndex = i + n;
    if(bottomIndex < graph.nodes.length - 1 && graph.nodes[bottomIndex].i > node.i){
      graph.addEdge(i, bottomIndex, Random().nextInt(10) + 1);
    }
    // Left (-1)
    int leftIndex = i - 1;
    if(leftIndex >= 0 && graph.nodes[leftIndex].j < node.j){
      graph.addEdge(i, leftIndex, Random().nextInt(10) + 1);
    }
  }
  // Find mst
  List<Maze_GraphEdge> mst = graph.kruskal();
  // Store result with coords
  List<Maze_LineSegment> result = [];
  // Iterate
  for (Maze_GraphEdge edge in mst) {
    result.add(
      Maze_LineSegment(start: graph.nodes[edge.u].toLinePoint(), end: graph.nodes[edge.v].toLinePoint())
    );
  }
  return result;
}

// ignore: must_be_immutable
class MazeWidget extends StatelessWidget{
  late int size = 0;
  late List<Maze_LineSegment> mazeLines = [];
  MazeWidget({
    this.size = 10,
    Key? key
  }) : super(key: key){
    mazeLines = generateMaze(size+2);
  }

  @override
  Widget build(BuildContext context){
    return Container(
      width: 300,
      height: 300,
      padding: EdgeInsets.all(10),
      clipBehavior: Clip.antiAlias,
      color: Colors.black,
      child: FittedBox(
        fit: BoxFit.fitHeight,
        child: CustomPaint(
            size: Size(size.toDouble(), size.toDouble()),
            painter: MazeWidgetPainter(mazeLines: mazeLines),
          ),
      ),
    );
  }
}

class MazeWidgetPainter extends CustomPainter{
  final List<Maze_LineSegment> mazeLines;
  final Paint _paint = Paint();
  MazeWidgetPainter({
    required this.mazeLines
  }){
    _paint.strokeWidth = 0.5;
    _paint.strokeJoin = StrokeJoin.miter;
    _paint.strokeCap = StrokeCap.square;
    _paint.color = Colors.white;
  }
  @override
  void paint(Canvas canvas, Size size){
    for (Maze_LineSegment line in mazeLines) {
      canvas.drawLine(
        Offset(line.start.j.toDouble(), line.start.i.toDouble()), 
        Offset(line.end.j.toDouble(), line.end.i.toDouble()), 
        _paint
      );
    }
  }
  @override
  bool shouldRepaint(CustomPainter old){
    return false;
  }
}