#
# Ext::Window tests
#

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ext'

class Test_window < Test::Unit::TestCase
  def test_basic
    w= Ext::Window.new
    assert(w.render.include?('height:200') & w.render.include?('width:300'), 'Basic test')
    assert(w.render.include?('.show();'), 'Defaults to .show')
    b= w.render do |win|
      win << {:show=>false}
    end
    assert(!b.include?('.show();'), 'If set :show=>false, do not show')
  end

  def test_before_render
    w= Ext::Window.new


    w.before_render do
     js( "alert('x');")
    end

    w.after_render do
      js(Ext::Button.new(),";alert('y')")
    end
    a= w.render
    assert( a.index("alert('x')") == 0,"Before_render at start")
    assert( a.index("alert('y')") > a.index("alert('x')"),"Before_render put before after_render")
  end
end
