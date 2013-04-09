#Requires

ruby 1.9.x and mongoDB 2.0.0 or later

#Setup

git clone https://github.com/mguinada/maybe_later.git
gem install bundle
bundle install
bundle exec rspec
bundle exec rake db:populate
bundle exec rackup
http://localhost:9292
login/passwd: user@example.com / password