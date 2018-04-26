require './lib/mastermind.rb'
require 'sinatra'
require 'sinatra' 
require  'sinatra/reloader' if development?

get '/' do
	"<h1>Sinatra Mastermind </h1>" 
end