require 'capybara/rspec'
require_relative '../app/app'
require_relative '../data_mapper_setup'

Capybara.app = BookmarkManager