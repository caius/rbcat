require "minitest/autorun"

class CatTest < Minitest::Test
  def setup
    @cat = Cat.new(["foo.txt"])
  end

  def test_that_cat
end
