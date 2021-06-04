class Square

    DELTAS = [[-1,-1],[-1,0],[-1,1],[0,1],[1,1],[1,0],[1,-1],[0,-1]]

    def initialize(board, pos)
        @bomb = false 
        @flagged = false
        @revealed = false
        @pertaining_board = board
        @neighbors = Square.get_neighbors(pos)
    end
    def self.get_neighbors(pos)
        neighbors = []
        row, col = pos
        DELTAS.each do |delta|
            delta_row, delta_col = delta
            new_row = row + delta_row
            new_col = col + delta_col
            if (0..8).include?(new_row) && (0..8).include?(new_col)
                neighbors << [new_row, new_col]
            end
        end
        neighbors
    end
    def inspect
        {'has a bomb?' => @bomb, 'flagged?' => @flagged, 'revealed?' => @revealed, 'neighbors' => @neighbors}
    end

    def to_s
        if @revealed
            return 'B' if @bomb 
            return '_'
        end
        return 'F' if @flagged
        return '*'
    end
    def reveal 
        return if @flagged
        @revealed = true unless @revealed
    end
    def set_bomb
        @bomb = true
    end

    def flag
        return if @revealed #cannot flag a revealed square
        @flagged = true unless @flagged
    end
    def unflag
        @flagged = false if @flagged
    end
    
end






