require 'test/unit'
require 'vbot'
class HelloWorldTest < Test::Unit::TestCase
	def test_hello_world
		assert_equal(HelloWorld.hello, 'Hello world!')
	end
end
