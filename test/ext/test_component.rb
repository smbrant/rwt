
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ext'

class TestComponent < Test::Unit::TestCase
  def test_basic
    c=Ext::Component.new({:xtype=>'tbtext',:text=>'<b>Fianseg:</b>'})
    assert(c.render.include?("xtype:'tbtext'") & c.render.include?("text:'<b>Fianseg:</b>'"), 'Basic.')
  end
  
  def test_xtype_exception
    c=Ext::Component.new({:test=>'test'})
    begin
      c.render # should issue an exception
    rescue => ex 
      assert(ex.message=="Should define the xtype","Exception if xtype not given")
    end 
  end
end
