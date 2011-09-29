#coding:UTF-8
require 'sinatra'
require 'haml'
require 'cgi'


configure do
  set :haml, :format => :html5
end
helpers do
  def h(s)
    CGI.escapeHTML s
  end
end

get '/css/sass/:name.css' do
  sass params[:name].intern
end
get '/js/coffee/:name.coffee' do
  coffee params[:name].intern
end

get '/' do
  haml :index
end

get '/:name' do
  name = params[:name].intern
  @scripts = ["/js/websocket.js","/js/jquery.js","/js/#{name}.js"]
  @stylesheets = ["/css/sass/main.css"]
  views = settings.views || "./views"
  found = nil
  @preferred_extension = :haml
  find_template(views,name,:haml) {|file| found = File.exists?(file)}
  @preferred_extension = :sass
  find_template(views,name,:sass) {|file| @stylesheets << "/css/sass/#{name}.css" if File.exists?(file)}
  @preferred_extension = :coffee
  find_template(views,name,:coffee) {|file| @scripts << "/css/coffee/#{name}.js" if File.exists?(file)}
  haml (found ? name : :blank)
end

