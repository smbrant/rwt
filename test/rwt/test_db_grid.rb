# 
# To change this template, choose Tools | Templates
# and open the template in the editor.
 

$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'rwt'
require 'rubygems'
require 'active_record'
require 'action_controller'

class Post < ActiveRecord::Base
end

class PostsController < ActionController::Base
end



Post.establish_connection(
  :adapter=> 'sqlite3',
  :database=> File.join(File.dirname(__FILE__),'development.sqlite3'),
  :timeout=> 5000
)

class TestDbGrid < Test::Unit::TestCase
  include Rwt
  def test_basic
    g= db_grid(:model=>Post)
    puts g.render
#    assert(false, 'Assertion was false.')
  end
end
