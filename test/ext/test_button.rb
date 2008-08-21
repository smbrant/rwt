# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ext'

class TestButton < Test::Unit::TestCase
  def test_basic
    b= Ext::Button.new(:text=>'button1')
    assert(b.render=="new Ext.Button({text:'button1'})", 'Basic test.')
  end
end
