require 'minitest/autorun'
require 'zoglmannk_hello_world'

class HelloTest < Minitest::Unit::TestCase

  def test_hello
    assert_equal "Hello world!",
      Hello.hi()
  end

  def test_any_hello
    assert_equal "Hello Kurt!",
      Hello.hi("Kurt")
  end

end
