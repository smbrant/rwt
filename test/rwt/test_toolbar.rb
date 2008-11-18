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
    assert(a.render == '(function(owner){var tb=new Ext.Toolbar({items:[]});if (owner==Rwt){tb.render(document.body)}if(!owner.tb){owner.tb=tb};})', 'Javascript different from expected')
  end
  
  def test_tbtext
    a= toolbar do |tb|
      tb << text('test')
    end
    assert(a.render.include?("text:'test'"))
  end

  def test_tbmenu
    a= toolbar do |tb|
      tb << text('test')
      tb << menu('menu1') do |mnu|
        mnu << menu_item('mnu11',:handler=>function())
        mnu << menu_item('xxxx',function('xxxxx'))
        mnu << menu_item( 'mnu11' , JS.new('ss') )
      end
    end
#    puts a.render
    assert(a.render.include?("xtype:'tbtext'"),"Should include a tbtext component")
  end
  
end
