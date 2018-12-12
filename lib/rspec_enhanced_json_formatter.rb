require 'json'
require 'rspec/core'
require 'rspec/core/formatters/base_formatter'

class RSpecEnhancedJSONFormatter < RSpec::Core::Formatters::BaseFormatter
  RSpec::Core::Formatters.register self, :example_passed, :example_failed, :example_pending, :dump_summary

  def initialize(output)
    super
    @output = output
  end

  def example_passed(passed)
    report_rspec_event(passed)
  end

  def example_failed(failure)
    report_rspec_event(failure)
  end

  def example_pending(pending)
    report_rspec_event(pending)
  end

  def dump_summary(summary)
    puts_json(
      type: 'summary',
      duration: summary.duration,
      total: summary.example_count,
      failed: summary.failure_count,
      pending: summary.pending_count
    )
  end


  private

  def report_rspec_event(notification)
    example = notification.example
    event = {
      type: 'test',
      id: example.id,
      name: example.full_description,
      duration: example.execution_result.run_time,
      status: example.execution_result.status,
      path: example.metadata[:file_path],
      line: example.metadata[:line_number],
    }

    if notification.respond_to?(:fully_formatted_lines)
      event[:error] = {
        message: notification.fully_formatted_lines(nil, RSpec::Core::Notifications::NullColorizer),
        tty_message: notification.fully_formatted_lines(nil)
      }

      exception = notification.exception
      if exception
        event[:error][:trace] = notification.formatted_backtrace
      end
    end

    puts_json(event)
  end

  def puts_json(hash)
    if $stdout.tty?
      @output.puts(JSON.pretty_generate(hash))
    else
      @output.puts(hash.to_json)
    end
    @output.flush
  end
end
