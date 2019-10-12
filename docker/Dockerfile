FROM ruby:2.6
LABEL maintainer="Dmitry Zhukov <dmitry.zhukov@gmail.com>"
WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install --binstubs
COPY . /app

# Add a script to be executed every time the container starts.
COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000
