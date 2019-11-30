FROM ruby:alpine3.10

WORKDIR /app

RUN gem install bundler
RUN apk add build-base
RUN apk add libsodium-dev

ADD . .

RUN bundle install

RUN apk del build-base

CMD ["bundle", "exec", "ruby", "bot.rb"]
