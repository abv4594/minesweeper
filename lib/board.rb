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

    def render
        puts (0..9).to_a.join(' ')
        @grid.each_with_index do |row,i|
            print i.to_s + ' '
            row.each {|square| print square.to_s + ' '}
            print "\n"
        end
    end


end

