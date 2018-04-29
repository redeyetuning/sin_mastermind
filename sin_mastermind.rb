#require './lib/mastermind.rb'
require 'sinatra'
#require  'sinatra/reloader' if development?

def gen_col_options
	cols = ["Blue", "Green", "Orange", "Purple", "Red", "Yellow"]
	cols.map{|x| "<option value='#{x}'>#{x}</option>"}.join
end

def gen_pegs css_class
	squares = *(1..48)
	squares.map{|x| "<div class ='#{css_class}' id = #{x}></div>"}.join
end


get '/' do
	guess_pegs = gen_pegs("guess-peg")
	cor_guess_pegs = gen_pegs("cor-guess-peg")
	col_options = gen_col_options
	erb :board, locals: {:guess_pegs => guess_pegs, :cor_guess_pegs => cor_guess_pegs, :col_options => col_options} 
end