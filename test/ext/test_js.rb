$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'rwt'

class TestJs < Test::Unit::TestCase
  def test_basic
    a= JS.new(
      "alert('teste');",
      "alert('teste2');",
      "b=", Ext::Button.new(:text=>'bb'),';',
      'b.show();'
    ).render
    assert(a=="alert('teste');alert('teste2');b=new Ext.Button({text:'bb'});b.show();", 'Basic test.')
  end

  def test_block
    a= JS.new(
      "alert('teste');",
      "alert('teste2');",
      "b=", Ext::Button.new(:text=>'bb') do |b|
              b<< {:text=>'bx'}
            end,';'
      ).render
    assert(a=="alert('teste');alert('teste2');b=new Ext.Button({text:'bx'});","Block")
  end
  
  def test_js_render
    a= js('a','b').render
    assert(a=="ab","Simple js render")
  end
end
