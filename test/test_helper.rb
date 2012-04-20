require "restfolia"

require "minitest/autorun"
require "minitest/reporters"
require "webmock/minitest"

require "support/json_samples"
require "support/stub_helpers"

WebMock.disable_net_connect!

MiniTest::Unit.runner = MiniTest::SuiteRunner.new
MiniTest::Unit.runner.reporters << MiniTest::Reporters::SpecReporter.new
