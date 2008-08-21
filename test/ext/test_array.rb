$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'ext'
require 'active_record'

class Cost < ActiveRecord::Base
end

Cost.establish_connection(
  :adapter=> 'sqlite3',
  :database=> File.join(File.dirname(__FILE__),'development.sqlite3'),
  :timeout=> 5000
)


class TestClass
  attr_accessor :attrx 
end

class TestArray < Test::Unit::TestCase
  def test_json
#    a=[1,2,3,4]
#    x= a.to_ext_json
#    assert(x.include?('"fixnums": [1, 2, 3, 4]') && x.include?('"results": 4'),'Basic')
  end
#  
#  def test_json_class
#    a=[TestClass.new,1,3,4]
#    x= a.to_ext_json
#    assert(x.include?('test_classes'),'Underscore and pluralize default')
#  end
end
