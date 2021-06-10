class Square

    require 'colorize'

    attr_accessor :content, :neighbors_with_bomb, :neighbors

    DELTAS = [[-1,-1],[-1,0],[-1,1],[0,1],[1,1],[1,0],[1,-1],[0,-1]]

    def initialize(board, pos)
        @bomb = false 
        @flagged = false
        @revealed = false
        @pertaining_board = board
        @my_pos = pos
        @neighbors = Square.get_neighbors(pos)
        @neighbors_with_bomb = [] # to be defined when Board distributes bombs
        @content = ''

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
        {'has a bomb?' => @bomb, 'flagged?' => @flagged, 'revealed?' => @revealed, 'my_pos' => @my_pos, 'neighbors' => @neighbors, 'neighbors_with_bomb' => @neighbors_with_bomb}
    end

    def to_s(cheat = false)
        return 'B'.colorize(:red) if has_bomb? && cheat
        return 'F'.colorize(:blue) if @flagged
        return @content unless @content.empty?
        if @revealed 
            return 'B'.colorize(:red) if has_bomb?
            return '_'
        end
        return '*'.colorize(:green)

    end
    def reveal
        @revealed = true
    end

    def set_bomb
        @bomb = true
    end

    def flag
        return if @revealed #cannot flag a revealed square
        @flagged = !@flagged
    end
    def has_bomb?
        @bomb
    end
    def set_neighbors_with_bomb
        @neighbors_with_bomb = @neighbors.select {|pos| @pertaining_board[pos].has_bomb?}
    end
    def revealed?
        @revealed
    end
    def flagged?
        @flagged
    end
   

end






