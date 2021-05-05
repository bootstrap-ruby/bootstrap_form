ARG DISTRO=buster
ARG RUBY_VERSION=2.6

FROM ruby:$RUBY_VERSION-$DISTRO

RUN mkdir -p /app
ENV HOME /app
WORKDIR /app

ENV GEM_HOME $HOME/vendor/bundle
ENV BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH ./bin:$GEM_HOME/bin:$PATH
RUN (echo 'docker'; echo 'docker') | passwd root

# Yarn installs nodejs.
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt update -y -q && \
    apt install -y -q yarn sqlite3

# Ruby now comes with bundler, but we're not using the default version yet, because we were using
# a newer version of bundler already. Ruby 3 comes with Bundler 2.2.3. Ruby 2.7 has Bundler 2.1.2,
# which is still behind what we were using.
RUN gem install bundler -v 2.1.4

EXPOSE 3000
