require "bundler/setup"
require "rspec_enhanced_json_formatter"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# See also: https://github.com/rspec/rspec-core/blob/v3.8.0/spec/support/formatter_support.rb
def run_example_specs_with_formatter(formatter)
  cmd = [
    'rspec',
    '--format', formatter, '--order', 'defined',
    'spec/fixtures/example_spec_.rb'
  ]

  IO.popen(cmd).read
end

def parse_json_lines(text)
  text.split("\n").map { |l| JSON.parse(l) }
end
