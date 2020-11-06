FROM ruby:2.7.1

# Install dependencies
RUN apt-get update && apt-get install -qq -y --no-install-recommends \
build-essential libpq-dev imagemagick git-all nano

# Set path
ENV INSTALL_PATH /gameon-api

# Create directory
RUN mkdir -p $INSTALL_PATH

# Set path as the main directory
WORKDIR $INSTALL_PATH

# Copy Gemfile into the container.
COPY Gemfile ./

# Set the path to the gems
ENV BUNDLE_PATH /box

# Copy code into the container
COPY . .