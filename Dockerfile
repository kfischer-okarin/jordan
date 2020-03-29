FROM ruby:2.7.0

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY core ../core

COPY rails/Gemfile rails/Gemfile.lock ./

RUN bundle install

COPY rails .

ENV RAILS_ENV production
ENV RACK_ENV production

# TODO: Delete when having DB
RUN rails db:create db:migrate

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
