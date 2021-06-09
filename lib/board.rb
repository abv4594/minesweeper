require_relative './square.rb'
require 'byebug'
require 'io/console'

ALREADY_FLAGGED_MSG = "You cannot reveal a flagged tile! First unflag it."
ALREADY_REVEALED_MSG = "Tile already revealed. Pick another one."

class Board
    NUM_BOMBS = 13
    GRID_SIZE = 9
   
    def initialize 
        @grid = Array.new(GRID_SIZE){Array.new(GRID_SIZE)}
        @grid.map!.with_index do |row, row_num| 
            row.map.with_index {|square, col_num| Square.new(self,[row_num, col_num])}
        end

    end
    
    def [](pos)
        row,col = pos
        @grid[row][col]
    end

    def prompt_error(msg)
        puts
        puts msg.colorize(:blue)
        print "Press a key to continue."
        STDIN.getch
        print "            \r"
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

    def reveal_all(pos)
        return unless self[pos].content.empty? 
        return if self[pos].has_bomb?
        return if self[pos].revealed?
        self[pos].reveal
        if self[pos].neighbors_with_bomb.count > 0
            self[pos].content = self[pos].neighbors_with_bomb.count.to_s
            return
        end
        self[pos].neighbors.each {|pos| reveal_all(pos)}
    end



    # def reveal_all(pos,first)
    #     return unless self[pos].content.empty?
    #     return if self[pos].has_bomb?
    #     return if !first && self[pos].revealed?
    #     if self[pos].neighbors_with_bomb.count > 0
    #         self[pos].reveal_neighbor
    #         self[pos].content = self[pos].neighbors_with_bomb.count.to_s
    #         return 

    #     end 
    #     self[pos].reveal_neighbor    
    #     self[pos].neighbors.each {|pos| reveal_all(pos,false)}
    # end 

    def won?
        @grid.flatten.count {|square| square.revealed?} == GRID_SIZE * GRID_SIZE - NUM_BOMBS
    end
    def lost?(pos)
        self[pos].has_bomb?
    end
    def flagged?(pos)
        self[pos].flagged?
    end
    def revealed?(pos)
        self[pos].revealed?
    end
    def neighbors(pos)
        self[pos].neighbors
    end
end

# test:

if __FILE__ == $PROGRAM_NAME

    b = Board.new
    b.fill_bombs
    until b.won?
        system("clear")
        puts
        b.render
        puts
        puts "Please enter a position to reveal:"
        pos_raw = gets.chomp
        pos = pos_raw.split(",").map(&:to_i)
        if b.flagged?(pos)
            b.prompt_error(ALREADY_FLAGGED_MSG)
            continue
        end
        if b.revealed?(pos)
            b.prompt_error(ALREADY_REVEALED_MSG)
            continue
        end
        b.reveal(pos)
        if b.lost?(pos)
            break
        end 
        b.neighbors(pos).each {|pos| b.reveal_all(pos)}
    end
    system ("clear")
    b.render
    puts
    b.render(true)
    puts

    if b.won? 
        puts "You won! Congratulations!"
    else
        puts "Bomb!!!!"
        puts "You lost!"
    end

end

