require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'

get "/" do
  @title = 'The Adventures of Sherlock Holmes | Home Page'
  @contents = File.readlines("data/toc.txt")
  erb :home
end

get "/chapters/1" do
  @title = 'The Adventures of Sherlock Holmes | Chapter 1'
  @contents = File.readlines("data/toc.txt")
  @text = File.read("data/chp1.txt")
  erb :chapter
end
