# frozen_string_literal: true

class RSpecOtelFormatter
  CURRENT_SPAN_KEY = OpenTelemetry::Context.create_key("current-span")

  RSpec::Core::Formatters.register(
    self,
    :start,
    :example_group_started,
    :example_group_finished,
    :example_started,
    :example_failed,
    :example_pending,
    :example_passed,
    :stop,
    :close
  )

  def initialize
    @tracer = OpenTelemetry.tracer_provider.tracer("otel-rspec")
    @span_stack = []
  end

  def start(_)
    start_span @tracer.start_span("suite")
  end

  def example_group_started(group_notification)
    start_span @tracer.start_span(group_notification.group.description)
  end

  def example_started(example_notification)
    start_span @tracer.start_span(example_notification.example.description)
  end

  def example_failed(_)
    finish
  end

  def example_pending(_)
    finish
  end

  def example_passed(_)
    finish
  end

  def example_group_finished(_)
    finish
  end

  def stop(_)
    finish
  end

  def dump_pending(_)
    # TODO?
  end

  def dump_failures(_)
    # TODO?
  end

  def dump_summary(_)
    # TODO?
  end

  def close(_)
    OpenTelemetry.tracer_provider.shutdown
  end

  private

  def start_span(span)
    ctx = OpenTelemetry::Context.current.set_value(CURRENT_SPAN_KEY, span)
    token = OpenTelemetry::Context.attach(ctx)

    @span_stack.push [token, span]
  end

  def finish
    token, span = @span_stack.pop

    OpenTelemetry::Context.detach(token)
    span.finish
  end
end
