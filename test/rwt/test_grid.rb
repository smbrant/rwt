# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'rwt'

class TestGrid < Test::Unit::TestCase
  include Rwt
  def test_basic
    g= grid() do |gr|
      gr << {:xtype=>'textfield'}
    end
#    puts g.render
    assert(g.render.include?('new Ext.grid.GridPanel('), 'Does not include standard header')
    assert(g.render.include?('columns'), 'Does not include columns property')
    assert(g.render.include?("xtype:'textfield'"), 'Does not include a textfield')
  end
end
