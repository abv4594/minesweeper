class Square


    def initialize
        @bomb = false 
        @flagged = false
        @revealed = false
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






