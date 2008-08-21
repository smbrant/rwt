# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ext'

class TestHash < Test::Unit::TestCase
  def test_basic
    a={}
    a.merge!({:test=>'test'})
    a.merge!({:test2=>'test2'})
    b= a.render do |x|
      x.merge!({:test3 => 'test3'})
    end
    assert(b.include?("test:'test'") & b.include?("test2:'test2'") & b.include?("test3:'test3'"), 'Assertion was false.')
  end
  
 
end
