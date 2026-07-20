FROM ruby:3.3.7
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV RAILS_ROOT /usr/src/app
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT
COPY Gemfile Gemfile
COPY . .
RUN bundle install
COPY docker-entrypoint.sh /usr/src/app/docker-entrypoint.sh
RUN chmod +x /usr/src/app/docker-entrypoint.sh
ENTRYPOINT ["./docker-entrypoint.sh"]
