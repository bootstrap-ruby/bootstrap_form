ARG RUBY_VERSION=3.0
ARG DISTRO=bullseye

FROM ruby:$RUBY_VERSION-$DISTRO

RUN mkdir -p /app
ENV HOME /app
WORKDIR /app

ENV GEM_HOME $HOME/vendor/bundle
ENV BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH ./bin:$GEM_HOME/bin:$PATH
RUN (echo 'docker'; echo 'docker') | passwd root

# Yarn installs nodejs.
# Rails wants a newer version of node that we get with the Debian distro.
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs
RUN corepack enable && corepack prepare yarn@stable --activate
RUN apt install -y -q yarn sqlite3

EXPOSE 3000
