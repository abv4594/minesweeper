require_relative './square.rb'

class Board
    NUM_BOMBS = 13
    def initialize 
        @grid = Array.new(9){Array.new(9)}
        @grid.map! {|row| row.map{|square| Square.new}}

    end
    
    def [](pos)
        row,col = pos
        @grid[row][pos]
    end


end

