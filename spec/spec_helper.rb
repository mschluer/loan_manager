# frozen_string_literal: true

require 'database_cleaner/active_record'
require 'faker'
require 'simplecov'

SimpleCov.start if ENV['COVERAGE'] == 'true'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.order = :random

  config.before(:suite) do
    # See https://github.com/DatabaseCleaner/database_cleaner
    DatabaseCleaner.strategy = :transaction

    Rails.application.load_seed
  end

  config.around(:each) do |example|
    # Reset Database to prior state after each example
    # See https://github.com/DatabaseCleaner/database_cleaner
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
