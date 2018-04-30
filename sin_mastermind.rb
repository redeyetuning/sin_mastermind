require './lib/mastermind.rb'
require 'sinatra'
require  'sinatra/reloader' if development?

enable :sessions

def gen_col_options
	cols = ["Blue", "Green", "Orange", "Purple", "Red", "Yellow"]
	cols.each_with_index.map{|x,i| "<option value='#{i}'>#{x}</option>"}.join
end

def gen_pegs css_class
	squares = *(1..48)
	squares.map{|x| "<div class ='#{css_class}' id = '#{x}'></div>"}.join
end

get '/' do
	erb :index
end

get '/player/guess' do
	guess = [params["col1"].to_i, params["col2"].to_i, params["col3"].to_i, params["col4"].to_i]
	guess = @@game.num_to_letter (guess)
	guess_text = @@game.move guess
	erb :player, locals: {:guess_pegs => @@guess_pegs, :cor_guess_pegs => @@cor_guess_pegs, :col_options => @@col_options, :guess_text => guess_text} 
end

get '/player' do
	@@guess_pegs = gen_pegs("guess-peg")
	@@cor_guess_pegs = gen_pegs("cor-guess-peg")
	@@col_options = gen_col_options
	@@game = Mastermind.new
	@@game.init_player
	erb :player, locals: {:guess_pegs => @@guess_pegs, :cor_guess_pegs => @@cor_guess_pegs, :col_options => @@col_options, :guess_text => nil }

end

