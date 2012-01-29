$:.unshift File.expand_path(File.dirname(__FILE__)) + "/../lib"
require "ostruct"

class BootSequence < OpenStruct
  def initialize(values = {environment: ENV['RACK_ENV'] || 'development'})
    super(values)
    ENV['RACK_ENV'] = environment.to_s
    yield self if block_given?
  end

  def execute
    puts "Booting #{environment.upcase} environment ..."

    require 'rubygems'
    require 'bundler'

    Bundler.require :default, environment.to_sym

    Mongoid.load!(File.expand_path(File.dirname(__FILE__)) + "/mongoid.yml")
    Mongoid.logger = Logger.new(log_file)

    require 'model'
    require 'warden_setup'
    require 'app'
    Application.environment = environment.to_sym
  end

  private
  def log_file
    log_directory = File.expand_path(File.dirname(__FILE__)) + "/../log/"
    Dir.mkdir(log_directory) unless File.directory?(log_directory)
    "#{log_directory}#{environment}.log"
  end
end