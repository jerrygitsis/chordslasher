FROM ruby:2.5.1

WORKDIR /chordslasher

COPY Gemfile Gemfile
RUN bundle install

COPY . .

EXPOSE 3000

CMD thin -R config.ru -p 3000 start