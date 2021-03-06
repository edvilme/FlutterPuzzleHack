
import 'dart:io';
import 'dart:math';

class PuzzleTilePosition {
	final int i;
	final int j;
	PuzzleTilePosition({required this.i, required this.j});
  @override
  String toString(){
    return "("+i.toString()+","+j.toString()+")";
  }
}

class PuzzleTileMovementCallback {
	final List<PuzzleTile?> row;
	final List<PuzzleTile?> column;
	PuzzleTile tile;
  int moveCount;
	PuzzleTileMovementCallback({
		required this.row, 
		required this.column, 
		required this.tile, 
    this.moveCount = 0
	});
}

class PuzzleTile {
	static int __counter = 0;
	late int __id;
	late PuzzleTilePosition correctPosition;
	late PuzzleTilePosition position;
	late String type;
	late String data;
	PuzzleTile({
		required this.correctPosition, 
		required this.position, 
		this.type = 'tile', 
		this.data = ''
	}){
		__id = PuzzleTile.__counter++;
	}
	int getID(){
		return __id;
	}
}

class PuzzleBoard {
	late int size;
	late List<List<PuzzleTile?>> tiles;
	late PuzzleTile emptyTile;

  Function? tileGenerator;

  late int moveCount = 0;
  late int shuffledMoves = 0;

	PuzzleBoard({
    required this.size, 
    this.tileGenerator
  }){
    int n = size;
		tiles = List<List<PuzzleTile?>>.generate(n, (index) => List<PuzzleTile?>.generate(n, (index) => null));
		for(int i = 0; i < n; i++){
			for(int j = 0; j < n; j++){
				tiles[i][j] = 
					PuzzleTile(
						correctPosition: PuzzleTilePosition(i: i, j: j), 
						position: PuzzleTilePosition(i: i, j: j),
						data: (n*i + j + 1).toString()
					);
					if(tileGenerator != null) tileGenerator!(tiles[i][j]);
			}
		}
		emptyTile = PuzzleTile(
			correctPosition: PuzzleTilePosition(i: n-1, j: n-1), 
			position: PuzzleTilePosition(i: n-1, j: n-1),
			type: 'empty'
		);
		tiles[n-1][n-1] = emptyTile;
	}

	// Get tiles, rows and cols
	List<PuzzleTile> getTiles(){
		List<PuzzleTile> result = List<PuzzleTile>.empty(growable: true);
		for(int i = 0; i < size; i++){
			for(int j = 0; j < size; j++){
				if(tiles[i][j] != null) result.add(tiles[i][j]!);
			}
		}
		// result.sort((a, b) => a.__id - b.__id);
		return result;
	}
	List<PuzzleTile?> getRow(int i){
		if(i < 0 || i >= size) return List<PuzzleTile?>.empty();
		return tiles[i];
	}
	List<PuzzleTile?> getColumn(int j){
		List<PuzzleTile?> result = List<PuzzleTile?>.empty(growable: true);
		if(j < 0 || j >= size) return result;
		for(int i = 0; i < size; i++){
			result.add(tiles[i][j]);
		}
		return result;
	}

	// Movements
	void moveTile(PuzzleTilePosition origin, PuzzleTilePosition dest, Function callback){
		PuzzleTile tile = tiles[origin.i][origin.j]!;
		tiles[dest.i][dest.j] = tile;
		tile.position = dest;

		tiles[origin.i][origin.j] = emptyTile;
		emptyTile.position = origin;

    // moveCount++;
		callback(
			PuzzleTileMovementCallback(row: getRow(dest.i), column: getColumn(dest.j), tile: tile, moveCount: moveCount)
		);
	}
	void moveInDirection(String direction, Function callback){
		PuzzleTile? curr;
		if(direction == 'up' && emptyTile.position.i > 0) {
		  	curr = tiles[emptyTile.position.i - 1][emptyTile.position.j];
		}
        else if(direction == 'down' && emptyTile.position.i < size - 1) {
          	curr = tiles[emptyTile.position.i + 1][emptyTile.position.j];
        }
        else if(direction == 'left' && emptyTile.position.j > 0) {
          	curr = tiles[emptyTile.position.i][emptyTile.position.j - 1];
        }
        else if(direction == 'right' && emptyTile.position.j < size - 1) {
          	curr = tiles[emptyTile.position.i][emptyTile.position.j + 1];
        }
		else{
			return;
		}
		moveTile(curr!.position, emptyTile.position, callback);
	}
	void moveToPosition(int i, int j, Function callback){
		if(emptyTile.position.i == i && emptyTile.position.j == j) return;
		// Horizontal
        if(emptyTile.position.i == i){
            // Left
            while(emptyTile.position.j > j) {
            	moveInDirection('left', callback);
            }
            // Right
            while(emptyTile.position.j < j) {
              	moveInDirection('right', callback);
            }
        }
        // Vertical
        if(emptyTile.position.j == j){
            // Up
            while(emptyTile.position.i > i) {
            	moveInDirection('up', callback);
            }
            // Down
            while(emptyTile.position.i < i) {
            	moveInDirection('down', callback);
            }
        }
        moveCount++;
	}

	// Remove
	void removeColumn(j){
		for(int i = 0; i < size; i++){
			tiles[i][j] = null;
		}
	}
	void removeRow(int i){
    while(i > 0){
      for(int j = 0; j < size; j++){
        tiles[i][j] = tiles[i-1][j];
        tiles[i][j]!.position = PuzzleTilePosition(i: i, j: j);
      }
      i--;
    }
    for(int j = 0; j < size; j++){
      tiles[0][j] = null;
    }
	}
	
	// Refill
	void refillColumn(int j){
		for (int i = 0; i < size; i++) {
			tiles[i][j] = PuzzleTile(correctPosition: PuzzleTilePosition(i: i, j: j), position: PuzzleTilePosition(i: i, j: j));
      if(tileGenerator != null) tileGenerator!(tiles[i][j]);
    }
	}
	void refillRow(int i){
		for (int j = 0; j < size; j++) {
			tiles[i][j] = PuzzleTile(correctPosition: PuzzleTilePosition(i: i, j: j), position: PuzzleTilePosition(i: i, j: j));
      if(tileGenerator != null) tileGenerator!(tiles[i][j]);
    }
	}

	// Shuffle
	void shuffle(int k, bool Function(List<List<PuzzleTile?>>)? f){
    int i = 0;
		while(i < k || f?.call(tiles) == false ) {
			moveInDirection(['up', 'down', 'left', 'right'][ Random().nextInt(4) ], (PuzzleTileMovementCallback c){});
      i++;
    }
    moveCount = 0;
    shuffledMoves = 0;
	}

  // Get state
  List<Map<String, int>> getCurrentState(){
		List<Map<String, int>> result = List<Map<String, int>>.empty(growable: true);
    for(int i = 0; i < size; i++){
      for(int j = 0; j < size; j++){
        if(tiles[i][j]!.type == 'empty') continue;
        result.add({
          "i": tiles[i][j]!.position.i, 
          "j": tiles[i][j]!.position.j
        });
      }
    }
    return result;
  }

  // Win, loose, score
  void win(Function? onWinCallback){
    if(onWinCallback != null) onWinCallback();
  }
  void loose(Function? onLooseCallback){
    if(onLooseCallback != null) onLooseCallback();
  }
  void score(Function? onScoreCallback){
    if(onScoreCallback != null) onScoreCallback();
  }
}