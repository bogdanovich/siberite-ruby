require 'rspec'
require 'pry'
require 'pry-byebug'
require "active_support/core_ext/hash"

spec_dir = File.dirname(__FILE__)

# make sure we load local libs rather than gems first
$: << File.expand_path("#{spec_dir}/../lib")

require 'kestrel'

TEST_CONFIG_FILE = File.expand_path("#{spec_dir}/kestrel/config/kestrel.yml")

RSpec.configure do |config|
  config.mock_with :rr

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  config.before do
    Kestrel::Config.environment = nil
    Kestrel::Config.load TEST_CONFIG_FILE
  end

  config.after do
    c = Kestrel::Client.new(*Kestrel::Config.default)
    c.available_queues.uniq.each do |q|
      c.delete(q) rescue nil
    end
  end
end
