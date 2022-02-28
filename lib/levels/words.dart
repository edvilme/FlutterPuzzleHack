import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:puzzle/level.dart';
import 'package:http/http.dart' as http;
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';

class WordAPIResponse {
  String word;
  String definition;
  String pronunciation;
  WordAPIResponse({
    required this.word, 
    required this.definition, 
    required this.pronunciation
  });

  factory WordAPIResponse.fromJson(Map<String, dynamic> json){
    return WordAPIResponse(word: json['word'], definition: json['definition'], pronunciation: json['pronunciation']);
  }
}

int counter = 0;

Widget WordLevel({
  Function? onNextLevel, 
  Function? onReset
}){
  counter++;
  return FutureBuilder<http.Response>(
    key: Key("level-words-promise-" + counter.toString()),
    future: http.get(Uri.parse('https://random-words-api.vercel.app/word')),
    builder: (context, snapshot) {
      if(snapshot.hasError || snapshot.data!.statusCode != 200) return Container();
      WordAPIResponse word = WordAPIResponse.fromJson(jsonDecode(snapshot.data!.body)![0]);
      int level = sqrt(word.word.length + 1).ceil();
      return Level(
        key: Key("level-words-" + counter.toString()),
        level: level,
        shuffled: true,
        instructions: word.definition + " (" + word.word + ")",
        tileGenerator: (PuzzleTile t){
          if((t.position.i * level + t.position.j) >= word.word.length){
            t.data = " ";
          } else {
            t.data = word.word[t.position.i * level + t.position.j];
          }
        },
        tileDecorator: (PuzzleTileWidget w){
          w.child = Text(
            w.data.data, 
            style: GoogleFonts.poiretOne(
              decoration: TextDecoration.none, 
              fontSize: w.size * 0.5
            ),
          );
        },
        onChange: (PuzzleTileMovementCallback callback, PuzzleBoard board){
          List<PuzzleTile> ordered = [...board.getTiles()];
          ordered.sort((a, b) => (a.position.i * level + a.position.j) - (b.position.i * level + b.position.j));
          for(int i = 0; i < word.word.length; i++){
            if(word.word[i] != ordered[i].data) return null;
          }
          return "win";
        },
        onNextLevel: (){
          onNextLevel!();
        },
        onReset: (){
          onReset!();
        },
      );
    },
  );
}


