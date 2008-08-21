# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ext'

class TestColumnModel < Test::Unit::TestCase
  def test_basic
    cm= Ext::Grid::ColumnModel.new([
  {:id=> 'id', :header=>'#',:width=>20,:dataIndex=>'id'},
  {:header=>'Title', :dataIndex=> 'cost[title]'},
  {:header=>'Text',:dataIndex=>'cost[text]'}
  ])
    assert(cm.render != '', 'Basic test.')
  end
end
