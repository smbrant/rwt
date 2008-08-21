# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ext'

class TestFunction < Test::Unit::TestCase
  def test_basic
    a= function(:a,:b,:c,'asdf').render
    assert(a=='function(a,b,c){asdf}', 'Render symbols as parameters')
  end
end
