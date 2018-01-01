# We use a custom docker image for our tests on CircleCI, defined here,
# and hosted on DockerHub. Having an image with pre-installed dependencies (like pandoc,
# phantomjs and postgres 9.6.x client tools) makes the test suite complete more quickly.
# See https://circleci.com/docs/2.0/custom-images
#
# If you change this Dockerfile, then from the project root, bump the version e.g. 0.0.2
# and build and push the image to DockerHub using user `woodpigeon` (password on request):
#
# $ docker build -t airslie/renalware-circleci-primary:0.0.x .circleci/
# $ docker login
# $ docker push airslie/renalware-circleci-primary:0.0.x
#
# and then update the docker image tag (eg 0.0.2) in `.circleci/config`.
# The next time a build is triggered on CircleCI the new image will be pulled and cached.

FROM ruby:2.5.0
MAINTAINER Tim Crowe <tim@airslie.com>
# Version 0.0.3 Updated Ruby 2.4.1 => 2.4.2 and Postgres 9.6 => 10.1
# Version 0.0.5 Updated Ruby 2.4.2 => 2.5.0

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update
RUN apt-get install -y \
  build-essential \
  libpq-dev \
  software-properties-common \
  nodejs \
  pandoc \
  --fix-missing \
  --no-install-recommends

RUN apt-get install -y libicu57

RUN wget http://security.ubuntu.com/ubuntu/pool/main/o/openssl/libssl1.0.0_1.0.2g-1ubuntu13.3_amd64.deb
RUN apt install -y ./libssl1.0.0_1.0.2g-1ubuntu13.3_amd64.deb

RUN wget http://apt.postgresql.org/pub/repos/apt/pool/main/p/postgresql-10/libpq5_10.1-1.pgdg14.04+1_amd64.deb
RUN apt install -y ./libpq5_10.1-1.pgdg14.04+1_amd64.deb

# Add a repo where we can get pg 10.1 client tools
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'
RUN apt-get update
RUN apt-get install -y postgresql-client-10

RUN wget -O /tmp/phantomjs.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar -xjf /tmp/phantomjs.tar.bz2 -C /tmp
RUN mv /tmp/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs

RUN gem install bundler
