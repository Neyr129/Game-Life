class Ground
    attr_accessor :ground, :cache

    #!!! Создать ground двумерный массив из объектов типа Cell(клетка) !!!
    #!!! Случайно "оживить клетки" на поле !!!
    def initialize(live_amount, x_size, y_size)
        @x_size = x_size
        @y_size = y_size
        @cache = Array.new
        @cache_index = 0

        #live_amount = (аргумент из консоли) или (7 по умолчанию)
        live_amount.nil? ? (@live_amount = 7) : (@live_amount = live_amount.to_i)
        @ground = Array.new(@x_size){|i| Array.new(@y_size){ |j| Cell.new i, j }}
        @ground.each do |line|
            line.each do |cell|
                cell.find_neigh(@ground)
                #(1/live_amount) шанс появления живой клетки
                rand(@live_amount) == 1 ? cell.life = true : cell.life = false
            end
        end

        pull_cache(@ground)
    end

    #!!! Проверить зациклилась ли игра,сделать один шаг, вывести в консоль !!!
    def start()
        while true
            make_step()
            check_repeating() #завершает игру в случае зацикливания
            output()
        end
    end

    #!!! Сделать один шаг, ground_temp - временное поле !!!
    def make_step()
        ground_temp = deep_copy(@ground)
        @ground.each do |line|
            line.each do |cell|    
                alive_count = 0
                #проверить всех соседей cell на живые клетки 
                cell.neighbours.each do |neigh| 
                    alive_count += 1 if  @ground[neigh[0]][neigh[1]].life == true
                end

                #оживить или убить клетку
                case cell.life
                when true
                    if  (alive_count > 3) or (alive_count < 2) 
                        ground_temp[cell.posy][cell.posx].life = false 
                    end
                when false
                    if alive_count == 3 
                        ground_temp[cell.posy][cell.posx].life = true 
                    end
                end
            end
        end
        sleep(0.01)
        @ground = deep_copy(ground_temp)
        return ground_temp
    end

    #!!! Вывод одного шага в консоль !!!
    def output()
        puts "\e[H\e[2j" 
        @ground.each do |temp_line|
            temp_line.each do |temp_cell|
                print ' '.alive if temp_cell.life == true
                print ' '.dead if temp_cell.life == false
            end
            puts "\n"
        end
    end

    #!!! Проверить на зацикленность !!!
    def check_repeating()
        @cache.each do |cache_ground|   
            (puts "КОНЕЦ ИГРЫ"; exit) if compare_playgrounds(cache_ground, @ground)
        end
        pull_cache(@ground)
    end

    #!!! сравнить два поля !!!
    def compare_playgrounds(ground1, ground2)
        check_same = true
        ground1.each_with_index do |ground1_line, i|                     
            ground1_line.each_with_index do |cache_cell, j|
                check_same = false if @ground[i][j].life != cache_cell.life 
            end
        end
        return check_same
    end

    #!!! pull playground в кэш !!! #
    def pull_cache(playground)
        @cache[@cache_index] = deep_copy(playground)
        @cache_index == 10 ? @cache_index = 0 : @cache_index += 1 
    end


end