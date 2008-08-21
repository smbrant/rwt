$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'rwt'

class TestWindow < Test::Unit::TestCase
  def test_basic
    win= Rwt::Window.new() do |w|
      w.title='Window Test'
      w << {:test=>'test1'}
      w << {:test=>'test2'}
      w << Rwt::Component.new(:test=>'test3')
    end
#    puts win.components.length
#    puts win.render
    assert(win.components[2].config[:test]=='test3', 'Child 3 must have a config of test3.') # A real component
    assert(win.components[0][:test]=='test1', 'Child 1 must have a config of test1.')  # Just a hash
  end
  
  def test_events
    win= Rwt::Window.new() do |w|
      w.on_close=function("alert('teste')")
    end
    puts win.render
  end
  
  
end
