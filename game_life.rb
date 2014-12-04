#!/usr/bin/env ruby
require 'byebug'
require_relative 'some_procs.rb'
require_relative 'cell_class.rb'
require_relative 'ground_class.rb'
 AMOUNT = ARGV[0]
 X_SIZE = 80
 Y_SIZE = 30

 playground = Ground.new(AMOUNT, Y_SIZE, X_SIZE)
 playground.start()

