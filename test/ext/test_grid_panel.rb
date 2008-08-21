
$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ext'

class TestGridPanel < Test::Unit::TestCase
  def test_basic
    g= Ext::Grid::GridPanel.new({})
    assert(g.render == 'new Ext.grid.GridPanel({})', 'Basic test.')
  end
end
