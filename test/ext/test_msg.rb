# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ext'

class TestMsg < Test::Unit::TestCase
  def test_basic
#    puts Ext::Msg.show({:a=>'1',:b=>'2'}).render
#    puts Ext::Msg.confirm('a','b',Function.new("alert('x')")).render
#    assert(false, 'Assertion was false.')
  end
end
