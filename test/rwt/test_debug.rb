# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'rwt'

class TestDebug < Test::Unit::TestCase
  def test_basic
    assert(Ext::Debug.active? == false, 'Defaults to no debug')
    Ext::Debug.start
    assert(Ext::Debug.active?, 'Debug set to true')
  end
end
