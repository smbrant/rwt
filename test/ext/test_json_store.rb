# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ext'

class TestJsonStore < Test::Unit::TestCase
  def test_json_store
    a= Ext::Data::JsonStore.new({
              :url=> '/cidade/index.json',
              :root=> 'cidade',
              :autoLoad=> true,
              :fields=> ['id', 'nome','uf']
          })
#     puts a.render
#    assert(false, 'Assertion was false.')
  end
end
