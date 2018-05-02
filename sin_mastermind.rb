require './lib/mastermind.rb'
require 'sinatra'
require  'sinatra/reloader' if development?

enable :sessions

def gen_col_options
	cols = ["Blue", "Green", "Orange", "Purple", "Red", "Yellow"]
	cols.map{|x| "<option value='#{x.downcase}'>#{x}</option>"}.join
end

def gen_pegs css_class, border=true
	squares = *(1..48)
	if border 
		squares.map{|x| if x<5 then "<div class='top-square'><div class ='#{css_class}' id = '#{css_class}#{x}'></div></div>" else "<div class='square'><div class ='#{css_class}' id = '#{css_class}#{x}'></div></div>" end}.join
	else
		squares.map{|x| "<div class ='#{css_class}' id = '#{css_class}#{x}'></div>"}.join
	end
end

def board_init
	@@guess_pegs = gen_pegs("guess-peg")
	@@cor_guess_pegs = gen_pegs("cor-peg", false)
	@@col_options = gen_col_options
	@@game = Mastermind.new
end

def col_pegs
	@@guess_peg_cols = @@game.peg_cols("guess")
	@@cor_peg_cols = @@game.peg_cols("cor")
end

get '/' do
	erb :index
end


get '/player' do
	board_init
	@@game.init_player
	intro = "<p>A.I. has chosen a 4 colour code for you to guess - try to guess the pattern within twelve turns!</p>
	<p>Once you submit a guess, the A.I. provides feedback by placing from zero to four 'clue pins' - </p></br> 
<ul><li>- A BLACK PIN is displayed for each guess digit which is of the correct color AND in the correct position.</li> 
</li>- A WHITE PIN is displayed for each guess digit whoses colour matchesthe code but is not in the correct position.</li></ul>
"
	erb :player, locals: {:parent => "player", :intro => intro, :guess_pegs => @@guess_pegs, :cor_guess_pegs => @@cor_guess_pegs, :col_options => @@col_options, :guess_text => nil, :guess_peg_cols => nil, :cor_peg_cols => nil }

end

get '/player/guess' do
	guess = [params["col1"], params["col2"], params["col3"], params["col4"]]
	guess_text = @@game.move guess
	col_pegs
	intro = "You have x turns left"
	erb :player, locals: {:parent => "player", :intro => intro, :guess_pegs => @@guess_pegs, :cor_guess_pegs => @@cor_guess_pegs, :col_options => @@col_options, :guess_text => guess_text, :guess_peg_cols => @@guess_peg_cols, :cor_peg_cols => @@cor_peg_cols} 
end

get '/ai' do
	board_init
	intro = "<p>Choose a 4 colour code for the A.I. to guess!"
	erb :player, locals: {:parent => "ai", :intro => intro, :guess_pegs => @@guess_pegs, :cor_guess_pegs => @@cor_guess_pegs, :col_options => @@col_options, :guess_text => nil, :guess_peg_cols => nil, :cor_peg_cols => nil}
end

get '/ai/guess' do
	code = [params["col1"], params["col2"], params["col3"], params["col4"]]
	guess_text = @@game.ai_plays code 
	col_pegs
	erb :ai, locals: {:guess_pegs => @@guess_pegs, :cor_guess_pegs => @@cor_guess_pegs, :guess_text => guess_text, :guess_peg_cols => @@guess_peg_cols, :cor_peg_cols => @@cor_peg_cols}
end