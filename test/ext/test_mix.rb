# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ext'

class TestMix < Test::Unit::TestCase
  def test_basic
    x= Ext::Mix.new({:a=>'a',:b=>'b'},['c','d']).render
    assert(x.include?('},[') & x.include?('a:') & x.include?('b:') & x.include?("'c'") & x.include?("'d'"), 'Basic test.')
  end
end
