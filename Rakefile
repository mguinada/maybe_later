require 'rubygems'
require 'rspec/core/rake_task'
require File.dirname(__FILE__) + '/lib/boot'

task :default => 'spec'

RSpec::Core::RakeTask.new do |task|
  task.rspec_opts = ["-c", "-f documentation", "-r ./spec/spec_helper.rb"]
  task.pattern    = 'spec/**/*_spec.rb'
end

namespace :db do
  task :environment do
    BootSequence.new.execute
  end

  task :not_at_prd do
    unless %w[development test staging].include? ENV['RACK_ENV']
      raise "Can't use this task at an evironment other than DEV, TEST or STAGING"
    end
  end

  desc "deletes staging data from the database"
  task delete: [:environment, :not_at_prd] do
    [Reference, Link, User].each(&:delete_all)
  end

  desc "injects staging data into the database"
  task populate: [:environment, :not_at_prd, :delete] do
    users = []
    1.upto 100 do |i|
      users << User.create!(email: "email#{i}@example.com", password: "password")
    end

    links = []
    1.upto 1000 do |i|
      links << Link.create!(url: "link#{i}.example.org")
    end

    refs = []
    users.each do |user|
      1.upto 1000 do |i|
        refs << Reference.create!(link: links[i - 1],
                                  user: user,
                                  title: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras vehicula, leo nec aliquet lobortis",
                                  description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras vehicula, leo nec aliquet lobortis")
      end
    end
  end
end