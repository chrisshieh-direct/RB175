require 'sinatra'
require 'sinatra/reloader'

get "/" do
  @directory = Dir.glob("public/*").sort
  @directory.reverse! if params[:sort] == 'desc'
  erb :home
end
