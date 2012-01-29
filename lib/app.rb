require 'rubygems'
require 'bundler'
require 'sinatra'

Bundler.require :default, Sinatra::Application.environment

class Application < Sinatra::Base
  set :views, File.dirname(__FILE__)  + "/../views"
  set :public_folder, File.dirname(__FILE__) + "/../public"

  get '/' do
    haml :welcome
  end
end