class Game

    require_relative './board.rb'

    FLAGGED_MSG = "You cannot reveal a flagged tile! First unflag it."
    ALREADY_REVEALED_MSG = "Tile already revealed. Pick another one."
    WRONG_INPUT = "Please enter R/r or F/f followed by space and a position. Like r 3,3"


    def initialize
        @board = Board.new
    end

    def prompt
        system("clear")
        puts
        @board.render
        puts
    end

    def get_input
        puts "Please enter R to reveal or F to flag/unflag followed by space and position"
        puts "For ex.: R 3,3 or F 2,3"
        gets.chomp
    end

    def parse_cmd (raw_user_input)
         raw_user_input[0].upcase
    end

    def parse_pos (raw_user_input)
        raw_pos = raw_user_input[2..-1]
        raw_pos.split(",").map(&:to_i)
    end

    def check_input(raw_user_input)
        possible_cmd = raw_user_input[0]
        possible_pos = raw_user_input[2..-1]
        return false if raw_user_input.length != 5
        return false unless ["R","F"].include?(possible_cmd.upcase)
        return false unless raw_user_input[1] == " "
        return false unless possible_pos.split(",").all? {|digit| ("0".."8").include?(digit)}
        return true
    end

    def prompt_error(msg)
        puts
        puts msg.colorize(:red)
        print "Press a key to continue."
        STDIN.getch
        print "            \r"
    end

    def is_pos_flagged?(pos)
        @board.flagged?(pos)
    end

    def is_pos_revealed?(pos)
        @board.revealed?(pos)
    end

    def f_cmd(pos)
        @board.flag(pos)
        true
    end 

    def r_cmd(pos)
        if is_pos_flagged?(pos)
            prompt_error(FLAGGED_MSG)
            return true
        elsif is_pos_revealed?(pos)
            prompt_error(ALREADY_REVEALED_MSG)
            return true
        else
            @board.reveal(pos)
            return false if @board.lost?(pos)
            @board.neighbors(pos).each {|x| @board.reveal_all(x)}
            return true
        end
    end
            
    def run
        prompt
        raw_user_input = ""
        until check_input (raw_user_input)    
            unless raw_user_input == "" 
                prompt_error(WRONG_INPUT)
            end
            raw_user_input = get_input
        end

        pos = parse_pos(raw_user_input)
        cmd = parse_cmd(raw_user_input)

        case cmd
        when "F"
            return f_cmd(pos)
        when "R"
            return r_cmd(pos)
        end
    end

    def play 
        @board.fill_bombs
        keep_running = true
        until keep_running == false || @board.won?
            keep_running = self.run
        end

        puts
        @board.render(true)
        puts

        if @board.won?
            puts "You won! Congratulations!"
        else
            puts "Bomb!! You lost!"
        end
    end

end

if __FILE__ == $PROGRAM_NAME
    g = Game.new
    g.play
end








