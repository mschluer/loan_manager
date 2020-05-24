bundle exec rake db:prepare
bundle exec rake assets:precompile

rm tmp/pids/server.pid

bundle exec rails server -p 80
