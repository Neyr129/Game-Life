class Cell
    attr_accessor :life, :posy, :posx, :neighbours

    def initialize(i,j)
        @life = false
        @posy = i
        @posx = j
        @neighbours = Array.new(8)
    end

    #найти всех соседей
    def find_neigh(sq)
        @neighbours[0] = [@posy-1, @posx-1] if posy !=0 && posx !=0
        @neighbours[1] = [@posy-1, @posx]   if posy !=0 
        @neighbours[2] = [@posy-1, @posx+1] if !sq[posy-1].nil? && !sq[posy-1][posx+1].nil? && posy !=0 
        @neighbours[3] = [@posy, @posx-1]   if posx !=0
        @neighbours[4] = [@posy, @posx+1]   if !sq[posy][posx+1].nil?
        @neighbours[5] = [@posy+1, @posx-1] if !sq[posy+1].nil? && !sq[posy+1][posx-1].nil? && posx !=0
        @neighbours[6] = [@posy+1, @posx]   if !sq[posy+1].nil? && !sq[posy+1][posx].nil?
        @neighbours[7] = [@posy+1, @posx+1] if !sq[posy+1].nil? && !sq[posy+1][posx+1].nil?
        @neighbours.compact!
    end
end