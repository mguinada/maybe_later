Requires
--------

ruby 1.9.3

mongodb 2.0.0 or later

Setup
-----

git clone https://mguinada@bitbucket.org/mguinada/maybe_later.git

gem install bundle

bundle install

bundle exec rake db:populate

bundle exec rspec #optional

bundle exec rackup

http://localhost:9292

login/passwd: user@example.com/password