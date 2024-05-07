# frozen_string_literal: true

require 'yaml'
require 'bundler/setup'
Bundler.require(:default)

[
  './lib/initializers',
  './lib/models',
  './lib/services',
  './lib/workers'
].each do |dir|
  Dir["#{dir}/*.rb"].each { |file| require file }
end

require './app'
