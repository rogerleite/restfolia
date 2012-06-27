require "restfolia"

require "minitest/autorun"
require "minitest/reporters"
require "webmock/minitest"

WebMock.disable_net_connect!

MiniTest::Unit.runner = MiniTest::SuiteRunner.new
MiniTest::Unit.runner.reporters << MiniTest::Reporters::SpecReporter.new
