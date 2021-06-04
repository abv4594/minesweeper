require_relative './square.rb'
require 'byebug'

class Board
    NUM_BOMBS = 13
    def initialize 
        @grid = Array.new(9){Array.new(9)}
        @grid.map!.with_index do |row, row_num| 
            row.map.with_index {|square, col_num| Square.new(self,[row_num, col_num])}
        end

    end
    
    def [](pos)
        row,col = pos
        @grid[row][col]
    end

    def render
        puts (0..9).to_a.join(' ')
        @grid.each_with_index do |row,i|
            print i.to_s + ' '
            row.each {|square| print square.to_s + ' '}
            print "\n"
        end
    end

    def fill_bombs 
        positions = (0..8).to_a.product((0..8).to_a)
        bomb_positions = positions.sample(NUM_BOMBS)
        bomb_positions.each {|pos| self[pos].set_bomb}
    end

    def reveal(pos)
        self[pos].reveal
    end

    def my_pos(square)
        row,col = -1, -1
        debugger
        @grid.each_with_index do |r, ridx|
            if r.include?(square)
                row = ridx
                col = r.index(square)
            end
        end
        [row,col]
    end

    


end

