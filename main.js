class Board{
    constructor(n){
        this.pieces = [
            ['A', 'B', 'C', 'D'], 
            ['E', 'F', 'G', 'H'], 
            ['I', 'J', 'K', '*'], 
            ['M', 'N', 'O', 'L']
        ]
        this.emptyPosition = [2, 3];
    }
    getFreeColumn(){
        let result = [];
        for(let row of this.pieces){
            result.push(row[this.emptyPosition[1]]);
        }
        return result;
    }
    getFreeRow(){
        return this.pieces[this.emptyPosition[0]];
    }
    print(){
        for(let row of this.pieces){
            console.log(row.join('\t'))
        }
    }
    swapInDirection(direction){
        // console.log(`Swap ${direction}`)
        if(direction == 'up' && this.emptyPosition[0] > 0){
            let curr = this.pieces[this.emptyPosition[0] - 1][this.emptyPosition[1]];
            this.pieces[this.emptyPosition[0]][this.emptyPosition[1]] = curr;
            this.emptyPosition[0]--;
        }
        if(direction == 'down' && this.emptyPosition[0] < this.pieces.length - 1){
            let curr = this.pieces[this.emptyPosition[0] + 1][this.emptyPosition[1]];
            this.pieces[this.emptyPosition[0]][this.emptyPosition[1]] = curr;
            this.emptyPosition[0]++;
        }
        if(direction == 'left' && this.emptyPosition[1] > 0){
            let curr = this.pieces[this.emptyPosition[0]][this.emptyPosition[1] - 1];
            this.pieces[this.emptyPosition[0]][this.emptyPosition[1]] = curr;
            this.emptyPosition[1]--;
        }
        if(direction == 'right' && this.emptyPosition[1] < this.pieces.length - 1){
            let curr = this.pieces[this.emptyPosition[0]][this.emptyPosition[1] + 1];
            this.pieces[this.emptyPosition[0]][this.emptyPosition[1]] = curr;
            this.emptyPosition[1]++;
        }
        this.pieces[this.emptyPosition[0]][this.emptyPosition[1]] = '*';
    }
    swapToPosition(i, j){
        if(this.emptyPosition[0] == i && this.emptyPosition[1] == j) 
            return; 
        if(this.emptyPosition[0] == i){
            // Swap left
            while(this.emptyPosition[1] > j)
                this.swapInDirection('left');
            // Swap right
            while(this.emptyPosition[1] < j)
                this.swapInDirection('right');
        }
        if(this.emptyPosition[1] == j){
            // Swap up
            while(this.emptyPosition[0] > i)
                this.swapInDirection('up');
            // Swap down
            while(this.emptyPosition[0] < i)
                this.swapInDirection('down');
        }
    }

    shuffle(n = 20){
        for(let i = 0; i < n; i++){
            this.swapInDirection(['left', 'up', 'right', 'down'][ Math.floor(Math.random()*4) ]);
        }
    }
}

const b = new Board();
// b.shuffle();
b.print();
 console.log('----')
 b.swapToPosition(0, 3)
 b.print()
 console.log('----')
b.swapToPosition(0, 3)
b.print()
