require 'rubygems'
require 'bundler'
require 'sinatra'

Bundler.require :default, Sinatra::Application.environment

class Application < Sinatra::Base
  set :views, File.dirname(__FILE__)  + "/../views"

  get '/' do
    haml :welcome
  end
end