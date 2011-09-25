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

get '/css/:name.css' do
  sass params[:name].intern
end

get '/' do
  haml :index
end

get '/:name' do
  @scripts = ["/js/websocket.js","/js/jquery.js","/js/#{h params[:name]}.js"]
  @stylesheets = ["/css/main.css"]
  name = params[:name].intern
  views = settings.views || "./views"
  found = nil
  @preferred_extension = :haml
  find_template(views,name,:haml) {|file| found = File.exists?(file)}
  @preferred_extension = :sass
  find_template(views,name,:sass) {|file| @stylesheets << "/css/#{h params[:name]}.css" if File.exists?(file)}
  haml (found ? name : :blank)
end

