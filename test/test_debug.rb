$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ext'

class TestDebug < Test::Unit::TestCase
  def test_basic
    assert(Ext::Debug.active? == false, 'Defaults to no debug')
    Ext::Debug.start
    assert(Ext::Debug.active? == true, 'Activated')
    Ext::Debug.stop
    assert(Ext::Debug.active? == false, 'Deactivated')
    Ext::Debug.start
    assert(Ext::Debug.indent=='','Initially, nothing')
    Ext::Debug.incr_indent
    assert(Ext::Debug.indent=='  ','One increment')
    Ext::Debug.incr_indent
    assert(Ext::Debug.indent=='    ','Two increment')
    Ext::Debug.decr_indent
    assert(Ext::Debug.indent=='  ','One increment')
    Ext::Debug.decr_indent
    assert(Ext::Debug.indent=='','Nothing')
    Ext::Debug.stop
    assert(Ext::Debug.indent=='','Nothing')
    Ext::Debug.incr_indent
    assert(Ext::Debug.indent=='','Nothing')
    Ext::Debug.incr_indent
    assert(Ext::Debug.indent=='','Nothing')
    Ext::Debug.decr_indent
    assert(Ext::Debug.indent=='','Nothing')
    Ext::Debug.decr_indent
    assert(Ext::Debug.indent=='','Nothing')
    assert(Ext::Debug.lf=='','Nothing')
    Ext::Debug.start
    assert(Ext::Debug.lf=="\n",'Nothing')
  end
  
  def test_using
    a=[1,[21,22,23],Ext::Window.new({:x=>1,:y=>2,:show=>false}),3]
    Ext::Debug.start
    withDebug= a.render
    Ext::Debug.stop
    withoutDebug= a.render
    assert(withDebug.delete("\n").gsub('  ','') == withoutDebug,'The difference shouldb be only newlines and spaces')
  end
end
