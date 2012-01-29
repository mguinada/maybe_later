$:.unshift File.expand_path(File.dirname(__FILE__)) + "/lib"

require 'boot'

BootSequence.new.execute
run Application