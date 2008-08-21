# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'rwt'

class TestAppCmp < Test::Unit::TestCase
  include Rwt
  def test_basic
    ap = Rwt::App.new()
    ap=app
    puts ap.render
#    assert(false, 'Assertion was false.')
  end
end
