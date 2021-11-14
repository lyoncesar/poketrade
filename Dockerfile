FROM ruby:2.6.6-alpine

RUN apk --update add bash make git gcc binutils libc-dev postgresql-client postgresql-dev g++ nodejs yarn tzdata graphviz ttf-freefont

RUN gem install rails
RUN gem install pg
RUN gem install bundler

COPY Gemfile Gemfile.lock ./

RUN bundle config set --local with 'development test'
RUN bundle install --jobs $(nproc)
RUN yarn install && yarn cache clean --all && rm -rf /tmp/*

WORKDIR /app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
