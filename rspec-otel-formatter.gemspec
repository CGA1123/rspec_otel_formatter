# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rspec_otel_formatter/version"

Gem::Specification.new do |spec|
  spec.name = "rspec_otel_formatter"
  spec.version = RSpecOtelFormatter::VERSION
  spec.authors = ["Christian Gregg"]
  spec.email = ["christian@bissy.io"]
  spec.summary = "An RSpec Formatter that hooks into OpenTelemetry"
  spec.homepage = "https://github.com/CGA1123/rspec_otel_formatter"
  spec.license = "MIT"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`
      .split("\x0")
      .reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 2.5"

  spec.add_runtime_dependency "opentelemetry-sdk"
  spec.add_runtime_dependency "opentelemetry-exporter-otlp"
end
