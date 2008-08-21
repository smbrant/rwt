# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'

class TestOs < Test::Unit::TestCase
  def test_foo
    `ls` #an os command
    assert_equal 0, $?
  end
end
