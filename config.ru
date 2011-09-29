require 'sinatra'
require './app.rb'

run Sinatra::Application
require './websocket.rb'
