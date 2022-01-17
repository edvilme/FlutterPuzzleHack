
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle/level.dart';
import 'package:puzzle/levels/words.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';

void main(){
  runApp(
    MaterialApp(
      home: Container(
        color: Colors.amber,
        child: WordLevel()
      )
    )
  );
}
