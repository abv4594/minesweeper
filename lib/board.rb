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

    def reveal(pos)
        self[pos].reveal
    end

    def render(cheat = false)
        print "  "
        puts (0..8).to_a.join(' ')
        @grid.each_with_index do |row,i|
            print i.to_s + ' '
            row.each {|square| print square.to_s(cheat) + ' '}
            print "\n"
        end
    end

    def fill_bombs 
        positions = (0..8).to_a.product((0..8).to_a)
        bomb_positions = positions.sample(NUM_BOMBS)
        bomb_positions.each {|pos| self[pos].set_bomb}
        positions.each {|pos| self[pos].set_neighbors_with_bomb}
    end



    def reveal_all(pos,first)
        return unless self[pos].content.empty?
        return if self[pos].has_bomb?
        return if !first && self[pos].revealed?
        if self[pos].neighbors_with_bomb.count > 0
            self[pos].content = self[pos].neighbors_with_bomb.count.to_s
            puts self[pos].content
            return 

        end 
        self[pos].reveal_neighbor    
        self[pos].neighbors.each {|pos| reveal_all(pos,false)}
    end 


end

if __FILE__ == $PROGRAM_NAME

    b = Board.new
    b.fill_bombs
    b.render
    puts
    b.render(true)
    pos_raw = gets.chomp
    p pos_raw
    pos = pos_raw.split(",").map(&:to_i)
    p pos
    b.reveal(pos)
    b.reveal_all(pos,true)
    b.render

end

