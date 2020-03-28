# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# gem "rails"

group :development, :test do
  gem "rspec", "~> 3.9"
  gem "rubocop", "~> 0.80.1"
  gem "rubocop-rspec", "~> 1.38"
  gem "factory_bot", "~> 5.1"
  gem "pry-byebug", "~> 3.9"
  gem "timecop", "~> 0.9.1"
end

group :development do
  gem "guard-rspec", "~> 4.7"
end
