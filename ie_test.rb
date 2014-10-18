$LOAD_PATH.unshift File.expand_path('../', __FILE__)
require 'ie_runner'
require 'minitest/autorun'

class IETest < MiniTest::Unit::TestCase
  def setup
    @ier = IERunner.new
    @ier.visible = true
  end

  def teardown
    @ier.close
  end

  def test_translate
    @ier.goto "http://www.google.com/language_tools"
    @ier.wait_complete(30)
    assert_equal(false, @ier.html.empty?, "Document not loaded")
    source = @ier.element_by_id("source")
    refute_nil(source, "Element 'source' not found")

    submit_btn = @ier.element_by_id("gt-submit")
    refute_nil(submit_btn, "Element 'gt-submit' not found")
  end
end
