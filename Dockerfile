FROM ruby:2.6.3

COPY . /application
WORKDIR /application

# prepare yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn sqlite3

RUN gem install bundler && bundle install
RUN yarn install --check-files
RUN bin/rake db:create && bin/rake db:migrate && bin/rake db:prepare

ENTRYPOINT ./entrypoint.sh
