# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ext'

class TestMenu < Test::Unit::TestCase
  def test_basic
    m=Ext::Menu::Menu.new()
    assert(m.render=="new Ext.menu.Menu({})", 'Minimum return')
  end
  
  def test_block
    text=Ext::Menu::Menu.new.render do |mm|
      mm << {:teste=>'teste'}
    end
    assert(text=="new Ext.menu.Menu({teste:'teste'})","New things in a render call")
  end
end
