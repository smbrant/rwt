# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ext'

class TestFieldSet < Test::Unit::TestCase
  def test_basic
    fs= Ext::Form::FieldSet.new(:a=>'a')
    assert(fs.render == "new Ext.form.FieldSet({a:'a'})", 'Basic test')
  end
end
