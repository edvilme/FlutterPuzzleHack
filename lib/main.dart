/**
 * Submission for #FlutterPuzzleHack
 * Dedicated to Ana, for all her extraordinary support in this process. 
 * For helping me test early builds, proposing ideas and encouraging me
 * to contiunue development. 
 * 
 * Made with ❤️ by @edvilme.
 */
import 'dart:math';
import 'dart:io' as IO;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/io_client.dart';
import 'package:puzzle/level.dart';
import 'package:puzzle/levels/food.dart';
import 'package:puzzle/levels/gyro.dart';
import 'package:puzzle/levels/image.dart';

import 'package:puzzle/levels/numbers.dart';
import 'package:puzzle/levels/patterns.dart';
import 'package:puzzle/levels/tictactoe.dart';
import 'package:puzzle/levels/words.dart';
import 'package:puzzle/puzzlemodel.dart';
import 'package:puzzle/puzzlewidget.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(
    const MaterialApp(
      title: "!Puzzle",
      debugShowCheckedModeBanner: false,
      home: Game()
    )
  );
}

class Game extends StatefulWidget{
  const Game({Key? key}) : super(key: key);
  @override
  GameState createState() => GameState();
}

class GameState extends State<Game>{
  // ignore: non_constant_identifier_names
  final List ALL_LEVELS = [
    NumberLevelEasy, 
    WordLevel,
    NumberLevelMedium,
    PatternsLevelEasy,
    ImageLevel,
    GyroLevel,
    TicTacToeLevel,
    FoodLevel
  ];

  late Widget currentLevel;
  late int currentLevelIndex;

  final BannerAd adBanner = BannerAd(
    // INFO: https://developers.google.com/admob/ios/data-disclosure
    // TODO: Replace with app ID
    //adUnitId: "ca-app-pub-3940256099942544/2934735716",
    adUnitId: 'ca-app-pub-9565405994206865/9496086530',
    size: AdSize.fluid,
    request: AdRequest(),
    listener: BannerAdListener(),
  );


  @override
  void initState() {
    super.initState();
    adBanner.load();
    currentLevelIndex =  Random().nextInt(ALL_LEVELS.length);
    currentLevel = ALL_LEVELS[currentLevelIndex](
      onNextLevel: (){
        generateLevel(Random().nextInt(ALL_LEVELS.length));
      }, 
      onReset: (){
        generateLevel(currentLevelIndex);
      }
    );
  }

  void generateLevel(int index){
    setState(() {
      currentLevel = ALL_LEVELS[index](
        onNextLevel: (){
          generateLevel( Random().nextInt(ALL_LEVELS.length) );
        }, 
        onReset: (){
          generateLevel(index);
        }
      );
    });
  }
 

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Column(
        children: [
          Expanded(child: currentLevel), 
          Container(
            height: 40,
            color: Colors.grey.shade900,
            child: AdWidget(ad: adBanner,),
            alignment: Alignment.center,
          )
        ],
      ),
    );
  }
}