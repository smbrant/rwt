# 
# Rwt::SimpleApp tests
# 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'rwt'

class Test_app < Test::Unit::TestCase
  def test_just_prologue_epilogue
    a= Rwt::SimpleApp.new()
#    a=app()
    assert(a.render == a.prologue+a.epilogue, 'Render minumum render')
    b= a.render do |app|
      app<<['test1']
    end
    assert(b==a.prologue+"'test1'"+a.epilogue,"One field, minimum return")
    # flunk "TODO: Write test"
    # assert_equal("foo", bar)
  end
  
  def test_block_in_creation
    a= Rwt::SimpleApp.new([1,2,3]) do |app|
      app << [4,5]
    end
    assert(a.render==a.prologue+'1,2,3,4,5'+a.epilogue)
  end
 
end
