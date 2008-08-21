# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'rwt'

class TestToolbar < Test::Unit::TestCase
  include Rwt
  def test_basic
    a= toolbar
    assert(a.render == '(function(owner){onwer.tb=new Ext.Toolbar({items:[]});})', 'Javascript different from expected')
  end
end
