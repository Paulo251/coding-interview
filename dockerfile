FROM ruby:3.3.4

RUN apt-get update -qq && apt-get install -y \
    postgresql-client \
    nodejs \
    npm

WORKDIR /app


COPY Gemfile .


RUN gem update --system && \
    gem install bundler && \
    bundle install --jobs 4 --retry 3

COPY . .

EXPOSE 3000

CMD ["bin/rails", "server", "-b", "0.0.0.0"]