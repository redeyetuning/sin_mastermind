require './lib/mastermind.rb'
require 'sinatra'
require 'sinatra' 
require  'sinatra/reloader' if development?

def gen_pegs
	squares.map{|x| "<div class ='peg' id = #{x}>#{x}</div>"}
	<div class = "peg" id = "A1">A1</div>
end

get '/' do
	erb :board 
end