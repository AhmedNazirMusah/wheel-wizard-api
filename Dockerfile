# Use Ruby 3.1.3 as the base image
FROM ruby:3.1.3-slim

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    git \
    curl \
    postgresql-client

# Set working directory
WORKDIR /app

# Install bundler
RUN gem install bundler:2.4.6

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle install

# Copy the rest of the application
COPY . .

# Add a script to be executed every time the container starts.
COPY bin/render-build.sh /usr/bin/
RUN chmod +x /usr/bin/render-build.sh

# Expose port 3000
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
