ARG RUBY_VERSION=3.2
ARG DISTRO=bookworm

FROM ruby:$RUBY_VERSION-$DISTRO

ARG NODE_MAJOR=20

RUN mkdir -p /app
ENV HOME /app
WORKDIR /app

ENV GEM_HOME $HOME/vendor/bundle
ENV BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH ./bin:$GEM_HOME/bin:$PATH
RUN (echo 'docker'; echo 'docker') | passwd root

# Rails wants a newer version of node than we get with the Debian distro.
RUN apt-get install -y ca-certificates curl gnupg
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
RUN apt-get update
RUN apt-get install nodejs -y -q
RUN corepack enable
RUN apt-get install -y -q sqlite3

EXPOSE 3000
