class Square
    def initialize(board, pos)
        @bomb = false 
        @flagged = false
        @revealed = false
        @pertaining_board = board
        @my_pos = pos
    end
    def inspect
        {'has a bomb?' => @bomb, 'flagged?' => @flagged, 'revealed?' => @revealed, 'my_pos' => @my_pos}
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






