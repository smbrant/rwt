# To change this template, choose Tools | Templates
# and open the template in the editor.

# Queria tentar avaliar uma expressão qq. e se desse erro retornar ''


require 'test/unit'
require 'rwt'
require 'rubygems'
require 'active_record'

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

class Post < ActiveRecord::Base
end
Post.establish_connection(
  :adapter=> 'sqlite3',
  :database=> File.join(File.dirname(__FILE__),'development.sqlite3'),
  :timeout=> 5000
)

class TestErrorBaseMethodNotFound < Test::Unit::TestCase
  def test_foo
#    puts 'xxx'
#    p $:
#    puts $:.class
#    puts $:.unshift
#    assert(false, 'Assertion was false.')
#    flunk "TODO: Write test"
    # assert_equal("foo", bar)
  end
end




# 
# Test of DbGridWindow (simple window with database grid
# 

#$:.unshift File.join(File.dirname(__FILE__),'..','lib')
#
#require 'test/unit'
#require 'rwt'
#require 'rubygems'
#require 'active_record'
#require 'action_controller'
#
#class Post < ActiveRecord::Base
#end
#
#class PostsController < ActionController::Base
#end
#
#
#
#Post.establish_connection(
#  :adapter=> 'sqlite3',
#  :database=> File.join(File.dirname(__FILE__),'development.sqlite3'),
#  :timeout=> 5000
#)
#
#class TestGridWindow < Test::Unit::TestCase
#  def test_basic
#    page= Rwt::DbGridWindow.new({:model=>Post, :controller=>PostsController, :title=>'Test Data Grid'})
#    assert(page.render != '', 'Basic test.')
#  end
#end
