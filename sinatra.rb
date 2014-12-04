#!/usr/bin/env ruby
require 'sinatra'
require 'data_mapper' 
require 'dm-core'
require "slim"
require 'byebug'

require_relative 'settings.rb'
require_relative 'some_procs.rb'
require_relative 'cell_class.rb'
require_relative 'ground_class.rb'

set :public_folder, File.dirname(__FILE__) 
DataMapper::Logger.new($stdout, :debug)
DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/blog.db")

class Buttons
  include DataMapper::Resource

  property :id,         Serial    
  property :condition,  String, :length => 10000  
end

DataMapper.finalize
DataMapper.auto_migrate!
DataMapper.auto_upgrade!
 
before do
    @settings = Settings
end

######## СДЕЛАТЬ ШАГ #########
def make_step(playground)
    temp_str = ''
    playground.make_step.map do |temp_line|
        temp_line.map do |temp_cell|
            temp_cell.life ? '*' : ' '
        end.join
    end.join '0' 
end

########## ДОБАВИТЬ ЗАПИСЬ В БАЗУ ########
def add_to_db(str)
   condition = Buttons.create(:condition => str)
   condition.save 
end    

settings = Settings.new
playground = Ground.new(ARGV[0], Settings[:y_size], Settings[:x_size] )
Settings[:field_str] = make_step(playground)
add_to_db(Settings[:field_str])

####### ОБНОВИТЬ БАЗУ С ПОМОЩЬЮ СТРОКИ ###
def update_playground(str,playground)
    i = 0  
    playground.ground.each do |line|
        line.each do |cell|
            if (str[i] == '0')
                i += 1
            end
            if    (cell.life == true && str[i] == ' ') 
                cell.life = false
            elsif (cell.life == false && str[i] == '*')
                cell.life = true
            end
            i += 1 if i < str.length
        end
    end
end

######## ОБНОВЛЕНИЕ СТРАНИЦЫ  ###########
get '/', :provides => 'html' do
    @x_size = Settings[:x_size]
    @y_size = Settings[:y_size]
    @field_str = Settings[:field_str]
    @cond_count = Settings[:cond_count]
    slim :life
end

######### ПРЕДЫДУЩЕЕ СОСТОЯНИЕ #########
get '/previous' do 
    Buttons.last.destroy
    Settings[:field_str] = Buttons.last[:condition]
    update_playground(Settings[:field_str], playground)    
    return Settings[:field_str]
end

######### УБИТЬ #######################  
post '/kill' do    
    Settings[:field_str][params[:index].to_i] = ' '    
    add_to_db(Settings[:field_str])    
    update_playground(Settings[:field_str], playground) 
end

#########  ОЖИВИТЬ  #######################  
post '/live' do 
    Settings[:field_str][params[:index].to_i] = '*'
    add_to_db(Settings[:field_str])
    update_playground(Settings[:field_str], playground)
end

######## НАЖАТА КНОПКА NEXT #############
get '/next' do 
    Settings[:field_str] = make_step(playground)
    add_to_db(Settings[:field_str])
    @field_str = Settings[:field_str]
    return Settings[:field_str]
end

get '/inc_step' do 
    Settings[:cond_count] += 1 
    @cond_count = Settings[:cond_count].to_s
    return @cond_count
end

get '/dec_step' do 
    Settings[:cond_count] -= 1 
    @cond_count = Settings[:cond_count].to_s
    return @cond_count
end
######## НАЖАТА КНОПКА RESET ##########
post '/reset' do
    #получить размеры окна, если они введены 
    params[:y_size].match(/\d/) ? (Settings[:y_size] = @y_size = params[:y_size].to_i) : (@y_size = Settings[:y_size])
    params[:x_size].match(/\d/) ? (Settings[:x_size] = @x_size = params[:x_size].to_i) : (@x_size = Settings[:x_size])
    playground = Ground.new(ARGV[0],@y_size, @x_size)
    Settings[:field_str] = make_step(playground)
    Settings[:cond_count] = 0
    redirect('/')
end




































# Вот у меня, ну у вас тоже, есть внук

# Может кому-то нравится быть билл гейтсом. я про себя не говорю, мне просто нравится в такой позе