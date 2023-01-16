require "sinatra"
require "sinatra/reloader"
require 'tilt/erubis'

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = 'The Adventures of Sherlock Holmes | Home Page'
  erb :home
end

get "/chapters/:number" do
  redirect "/" unless (1..@contents.size).cover? params[:number].to_i
  @title = "Chapter #{params[:number]}: #{@contents[params[:number].to_i - 1]}"
  @chapter = File.read("data/chp#{params[:number]}.txt")
  erb :chapter
end

get "/show/:name" do
  "The name is #{params[:name]}"
end

get "/search" do
  @noquery = false
  @noquery = true unless params[:query]
  query = params[:query]
  @matches = {}
  max_files = @contents.size
  1.upto(max_files) do |x|
    next if @noquery == true
    testfile = File.read("data/chp#{x}.txt")
    if testfile.downcase.match(query.downcase)
      @matches[@contents[x - 1]] = [x]
      in_paragraphs(testfile).each_with_index do |graph, idx|
        @matches[@contents[x - 1]] << [graph, idx] if graph.downcase.match(query.downcase)
      end
    end
  end
  erb :search
end

not_found do
  redirect "/"
end

helpers do
  def in_paragraphs(str)
    paragraphs = str.split("\n\n")
  end

  def highlight(str, query)
    str.gsub(query, "<strong>#{query}</strong>")
  end
end
