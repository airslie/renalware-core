# We use a custom docker image for our tests on CircleCI, defined here,
# and hosted on DockerHub. Having an image with pre-installed dependencies (like pandoc,
# phantomjs and postgres 9.6.x client tools) makes the test suite complete more quickly.
# See https://circleci.com/docs/2.0/custom-images
#
# If you change this Dockerfile, then from the project root, bump the version e.g. 0.0.2
# and build and push the image to DockerHub using user `woodpigeon` (password on request):
#
# $ docker build -t airslie/renalware-circleci-primary:0.0.x ./circleci
# $ docker login
# $ docker push airslie/renalware-circleci-primary:0.0.x
#
# and then update the docker image tag (eg 0.0.2) in `.circleci/config`.
# The next time a build is triggered on CircleCI the new image will be pulled and cached.

FROM ruby:2.4.1
MAINTAINER Tim Crowe <tim@airslie.com>

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

# Add a repo where we can get pg 9.6 client tools
# RUN deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main
RUN add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main"
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get install -y postgresql-client-9.6

RUN wget -O /tmp/phantomjs.tar.bz2 http://airslie-public.s3.amazonaws.com/phantomjs-2.1.1-linux-x86_64.tar.bz2
RUN tar -xjf /tmp/phantomjs.tar.bz2 -C /tmp
RUN mv /tmp/phantomjs-2.1.1-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs
