import 'dart:math';

import 'package:flutter/material.dart';
import 'package:puzzle/level.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';

Map<String, Color> namedColors = {
  "Red": Colors.red, 
  "Green": Colors.green, 
  "Blue": Colors.blue, 
  "Orange": Colors.orange
};
void main() {
  runApp(
    MaterialApp(
      home: Center(
        child: LevelWidget()
      ),
    )
  );
}
