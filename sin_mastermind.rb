require './lib/mastermind.rb'
require 'sinatra'
require  'sinatra/reloader' if development?

enable :sessions

def gen_col_options
	cols = ["Blue", "Green", "Orange", "Purple", "Red", "Yellow"]
	cols.map{|x| "<option value='#{x.downcase}'>#{x}</option>"}.join
end

def gen_pegs css_class
	squares = *(1..48)
	squares.map{|x| "<div class ='#{css_class}' id = '#{css_class}#{x}'></div>"}.join
end

get '/' do
	erb :index
end

get '/player/guess' do
	guess = [params["col1"], params["col2"], params["col3"], params["col4"]]
	guess_text = @@game.move guess
	guess_peg_cols = @@game.peg_cols("guess")
	cor_peg_cols = @@game.peg_cols("cor")
	erb :player, locals: {:guess_pegs => @@guess_pegs, :cor_guess_pegs => @@cor_guess_pegs, :col_options => @@col_options, :guess_text => guess_text, :guess_peg_cols => guess_peg_cols, :cor_peg_cols => cor_peg_cols} 
end

get '/player' do
	@@guess_pegs = gen_pegs("guess-peg")
	@@cor_guess_pegs = gen_pegs("cor-peg")
	@@col_options = gen_col_options
	@@game = Mastermind.new
	@@game.init_player
	erb :player, locals: {:guess_pegs => @@guess_pegs, :cor_guess_pegs => @@cor_guess_pegs, :col_options => @@col_options, :guess_text => nil, :guess_peg_cols => nil, :cor_peg_cols => nil }

end

