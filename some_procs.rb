#цвета для клеток 
class String 
    def alive 
        "\e[41m#{self}\e[0m" 
    end

    def dead 
        "\e[47m#{self}\e[0m" 
    end
end

#копирование многомерного массива
class Object
   def deep_copy( object )
     Marshal.load( Marshal.dump( object ) )
   end
end