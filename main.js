class BoardTile {
    static count = 0;
    constructor(value, i, j){
        this.value = value;
        this.i = i;
        this.j = j;
        this.index = BoardTile.count++;
    }
}

class Board{
    constructor(n){
        const data = [
            ['A', 'B', 'C', 'D'], 
            ['E', 'F', 'G', 'H'], 
            ['I', 'J', 'K', ''], 
            ['M', 'N', 'O', 'L']
        ]
        this.pieces = data.map((row, i) => 
            row.map((cell, j) => new BoardTile(cell, i, j))    
        )
        this.emptyTile = this.pieces[2][3];
    }
    print(){
        for(let row of this.pieces){
            console.log(row.map(cell => cell.value).join('\t'))
        }
    }
    swapInDirection(direction){
        // console.log(`Swap ${direction}`)
        if(direction == 'up' && this.emptyTile.i > 0){
            let curr = this.pieces[this.emptyTile.i - 1][this.emptyTile.j];
            this.pieces[this.emptyTile.i][this.emptyTile.j] = curr;
            curr.i = this.emptyTile.i;
            curr.j = this.emptyTile.j;
            this.emptyTile.i--;
        }
        if(direction == 'down' && this.emptyTile.i < this.pieces.length - 1){
            let curr = this.pieces[this.emptyTile.i + 1][this.emptyTile.j];
            this.pieces[this.emptyTile.i][this.emptyTile.j] = curr;
            curr.i = this.emptyTile.i;
            curr.j = this.emptyTile.j;
            this.emptyTile.i++;
        }
        if(direction == 'left' && this.emptyTile.j > 0){
            let curr = this.pieces[this.emptyTile.i][this.emptyTile.j - 1];
            this.pieces[this.emptyTile.i][this.emptyTile.j] = curr;
            curr.i = this.emptyTile.i;
            curr.j = this.emptyTile.j;
            this.emptyTile.j--;
        }
        if(direction == 'right' && this.emptyTile.j < this.pieces.length - 1){
            let curr = this.pieces[this.emptyTile.i][this.emptyTile.j + 1];
            this.pieces[this.emptyTile.i][this.emptyTile.j] = curr;
            curr.i = this.emptyTile.i;
            curr.j = this.emptyTile.j;
            this.emptyTile.j++;
        }
        this.pieces[this.emptyTile.i][this.emptyTile.j] = this.emptyTile;
    }
    swapToPosition(i, j){
        if(this.emptyTile.i == i && this.emptyTile.j == j) 
            return; 
        if(this.emptyTile.i == i){
            // Swap left
            while(this.emptyTile.j > j)
                this.swapInDirection('left');
            // Swap right
            while(this.emptyTile.j < j)
                this.swapInDirection('right');
        }
        if(this.emptyTile.j == j){
            // Swap up
            while(this.emptyTile.i > i)
                this.swapInDirection('up');
            // Swap down
            while(this.emptyTile.i < i)
                this.swapInDirection('down');
        }
        return this.getPieces();
    }
    shuffle(n = 20){
        for(let i = 0; i < n; i++){
            this.swapInDirection(['left', 'up', 'right', 'down'][ Math.floor(Math.random()*4) ]);
        }
    }
    getPieces(){
        return this.pieces.flat().sort((a, b) => a.index - b.index);
    }
}
