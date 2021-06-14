class Game

    require_relative './board.rb'
    require 'yaml'

    FLAGGED_MSG = "You cannot reveal a flagged tile! First unflag it."
    ALREADY_REVEALED_MSG = "Tile already revealed. Pick another one."
    WRONG_INPUT = "Please enter R/r or F/f followed by space and a position. Like r 3,3"

    def self.ask_load_game
        puts
        puts "Enter L or l to load a previously saved game, or N/n for new game!"
        user_input = " "
        until "NnLl".include?(user_input)
            unless user_input == " "
                puts "Please enter L/l to load a game or N/n for new game."
            end
            user_input = gets.chomp
        end
        user_input.upcase
    end

    def self.ask_file_name
        puts
        puts "Please enter a filename:"
        gets.chomp
    end

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
        puts "Please enter a command as below:"
        puts "________________________________"
        puts "R (or r) followed by space and a position to reveal. Ex: R 3,3." 
        puts "F (or f) followed by space and a position to flag/unflag. Ex: F 1,2."
        puts "S (or s) followed by filename to save."
        gets.chomp
    end

    def parse_cmd (raw_user_input)
         raw_user_input[0].upcase
    end

    def parse_pos (raw_user_input)
        raw_pos = raw_user_input[2..-1]
        raw_pos.split(",").map(&:to_i)
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

    def flag_cmd(pos)
        @board.flag(pos)
        true
    end 

    def reveal_cmd(pos)
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
    
    def check_cmd(cmd)
        return false if cmd.empty?
        return false unless "RFS".include?(cmd)
        true
    end

    def check_pos(pos)
        return false unless pos.all? {|digit| (0..8).include?(digit)}
        true
    end

    def get_cmd
        cmd = ""
        puts "Please enter a command. R/r =  reveal, F/f = flag/unflag, S/s = save game"
        until check_cmd(cmd)
            puts "Wrong command. Enter R, F, or S to Reveal, Flag or Save" unless cmd.empty?
            cmd = gets.chomp.upcase
        end
        cmd
    end

    def get_pos
        puts "Please enter a position in the format 4,3 or 2,3"
        gets.chomp.split(",").map(&:to_i)
    end
    
    def get_filename
        puts "Please enter a file name"
        gets.chomp
    end
        

    def run
        prompt
        #debugger
        cmd = get_cmd
        if cmd == "S"
            filename = get_filename
        else
            pos = get_pos
        end

        case cmd
        when "F"
            return flag_cmd(pos)
        when "R"
            return reveal_cmd(pos)
        when "S"
            File.open(filename, "w") { |f| f.write(YAML.dump(self)) }
            puts "Game saved. See you soon!"
            exit
        end
    end



    def play 
        @board.fill_bombs unless @board.board_already_filled? 
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
    puts 
    system ("clear")
    puts "Welcome to ABV4594's Minesweeper game"
    puts "_____________________________________"
    puts
    user_option = Game.ask_load_game
    if user_option == "L"
        g = YAML.load(File.read(Game.ask_file_name))
    else
        g = Game.new
    end
    g.play
end








