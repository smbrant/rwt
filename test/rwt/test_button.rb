$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'rwt'

class TestButton < Test::Unit::TestCase
  def test_button_in_window
    win=Rwt::Window.new do |w|
      w << Rwt::Button.new(:text=>'button') do |b|
        b.on_click=function("Alert('button');")
      end
    end
    puts win.render
#    assert(false, 'Assertion was false.')
  end
end
