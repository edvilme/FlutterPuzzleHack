class PuzzleTile{
    static __counter = 0;
    constructor({i, j, type, value, data}){
        this.__id = PuzzleTile.__counter++;
        this.position = {i, j};
        this.value = value || ''
        this.data = data;

        if(type != 'empty'){
            this.type = ['red', 'green', 'blue', 'orange', 'purple'][ Math.floor( Math.random()*5 ) ]
        } else {
            this.type = 'empty'
        }
    }
}

class PuzzleBoard{
    constructor(n){
        this.size = n;
        this.tiles = [];
        for(let i = 0; i < n; i++){
            this.tiles[i] = [];
            for(let j = 0; j < n; j++){
                this.tiles[i][j] = new PuzzleTile({i, j, value: n * i + j + 1})
            }
        }
        this.emptyTile = new PuzzleTile({i: n-1, j: n-1, type: 'empty'})
        this.tiles[n-1][n-1] = this.emptyTile;
    }

    // Get tiles, rows and cols
    getTiles(){
        return this.tiles.flat().sort((a, b) => a.__id - b.__id);
    }
    getRow(i){
        if(i < 0 || i >= this.size) return [];
        return this.tiles[i];
    }
    getColumn(j){
        if(j < 0 || j >= this.size) return [];
        let result = [];
        for(let i = 0; i < this.size; i++){
            result.push(this.tiles[i][j]);
        }
        return result;
    }

    // Movements
    moveTile(origin, dest, callback){
        const tile = this.tiles[origin.i][origin.j];
        this.tiles[dest.i][dest.j] = tile;
        tile.position = dest;

        this.tiles[origin.i][origin.j] = this.emptyTile;
        this.emptyTile.position = origin;

        callback?.({row: this.getRow(dest.i), column: this.getColumn(dest.j)})
    }
    moveInDirection(direction, callback){
        let curr;
        if(direction == 'up' && this.emptyTile.position.i > 0)
            curr = this.tiles[this.emptyTile.position.i - 1][this.emptyTile.position.j];
        if(direction == 'down' && this.emptyTile.position.i < this.size - 1)
            curr = this.tiles[this.emptyTile.position.i + 1][this.emptyTile.position.j];
        if(direction == 'left' && this.emptyTile.position.j > 0)
            curr = this.tiles[this.emptyTile.position.i][this.emptyTile.position.j - 1];
        if(direction == 'right' && this.emptyTile.position.j < this.size - 1)
            curr = this.tiles[this.emptyTile.position.i][this.emptyTile.position.j + 1];
        if(curr == undefined) return
        this.moveTile(curr.position, this.emptyTile.position, callback);
    }
    movePosition(i, j, callback){
        if(this.emptyTile.position.i == i && this.emptyTile.position.j == j)
            return;
        // Horizontal
        if(this.emptyTile.position.i == i){
            // Left
            while(this.emptyTile.position.j > j)
                this.moveInDirection('left', callback)
            // Right
            while(this.emptyTile.position.j < j)
                this.moveInDirection('right', callback)
        }
        // Vertical
        if(this.emptyTile.position.j == j){
            // Up
            while(this.emptyTile.position.i > i)
                this.moveInDirection('up', callback)
            // Down
            while(this.emptyTile.position.i < i)
                this.moveInDirection('down', callback)
        }
    }

    // Remove
    removeColumn(j){
        for(let row of this.tiles){
            row[j] = undefined;
        }
    }
    removeRow(i, gravity){
        this.tiles[i] = new Array(this.size).fill(undefined)
    }
    // Refill
    refillColumn(j){
        this.tiles.forEach((row, i) => {
            row[j] = new PuzzleTile({i, j})
        })
    }

    shuffle(k = 10){
        for(let i = 0; i < k; i++){
            this.moveInDirection(['up', 'down', 'left', 'right'][ Math.floor(Math.random()*4) ])
        }
    }

    print(){
        for(let row of this.tiles){
            console.log(
                row.map(tile => tile.value).join('\t')
            )
        }
    }

}
