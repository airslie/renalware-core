# https://dzone.com/articles/using-docker-for-rails-development
# We use a custom docker image for our tests on CircleCI, defined here,
# and hosted on DockerHub. Having an image with pre-installed dependencies (like pandoc,
# phantomjs and postgres 9.6.x client tools) makes the test suite complete more quickly.
# See https://circleci.com/docs/2.0/custom-images
#
# If you change this Dockerfile, then from the project root, bump the version e.g. 0.0.3
# and build and push the image to DockerHub using user `woodpigeon` (password on request):
#
# $ docker build -t airslie/renalware-development:0.0.x .
# $ docker login
# $ docker push airslie/renalware-development:0.0.x
#
# and then update the docker image tag (eg 0.0.3) in `.circleci/config`.
# The next time a build is triggered on CircleCI the new image will be pulled and cached.

# Version 0.0.2 Updated Ruby 2.4.1 => 2.4.2
# Version 0.0.3 Updated Postgres 9.6 => 10.1
FROM ruby:2.4.2
MAINTAINER Tim Crowe <tim@woodpigeon.com>

# Install apt based dependencies required to run Rails as
# well as RubyGems. As the Ruby image itself is based on a
# Debian image, we use apt-get to install those.
RUN apt-get update
RUN apt-get install -y \
  build-essential \
  libpq-dev \
  software-properties-common \
  python-software-properties \
  nodejs \
  pandoc \
  --fix-missing \
  --no-install-recommends

# Add a repo where we can get pg 10 client tools
# RUN deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main
# RUN add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main"
# RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" >> /etc/apt/sources.list.d/postgresql.list'
RUN apt-get update
RUN apt-get install -y postgresql-client-10

RUN wget -O /tmp/phantomjs.tar.bz2 http://airslie-public.s3.amazonaws.com/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar -xjf /tmp/phantomjs.tar.bz2 -C /tmp
RUN mv /tmp/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs

# Configure the main working directory. This is the base
# directory used in any further RUN, COPY, and ENTRYPOINT
# commands.
RUN mkdir -p /app
WORKDIR /app

# Copy the Gemfile as well as the Gemfile.lock and install
# the RubyGems. This is a separate step so the dependencies
# will be cached unless changes to one of those two files
# are made.
# NB This does not work as .gemspec requries lib/version.rb etc
COPY Gemfile renalware-core.gemspec Gemfile.lock /app/
RUN mkdir -p /app/lib/renalware
COPY ./lib/renalware/version.rb /app/lib/renalware/version.rb
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy the main application.
# COPY . ./
# No we'll use a mount

# Expose port 3000 to the Docker host, so we can access it
# from the outside.
EXPOSE 3000

# The main command to run when the container starts. Also
# tell the Rails dev server to bind to all interfaces by
# default.
CMD ["bundle", "exec", "bin/web"]

