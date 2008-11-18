# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ext'

class TestVar < Test::Unit::TestCase
  def test_basic
    p= program(
      v=var(Ext::Window.new(:show=>false)),
      v.on({:activate=>function('alert("teste")')})
    ).render
    assert(p.include?(v.name+'='), 'Should create a javascript variable')
  end
  
  def test_property  # nao deu, queria poder atribuir valor a uma propriedade
    p= program(
      v=var(Ext::FormPanel.new(:url=>'/test')),
      v.url="'/new_test'"
#      v.show().xx(:teste=>'a',:t2=>'b')
    ).render
#    puts p
  end
end
