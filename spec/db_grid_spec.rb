require 'rwt'
include Rwt

require 'active_record'
require 'action_controller'


class TestModel < ActiveRecord::Base
end

class TestController < ActionController::Base
end

describe DbGrid do
  before(:each) do
    Rwt.clear
  end

  it "should generate a dbgrid" do
    @test=TestModel.new
    dbgrid(TestModel,TestController)
    puts Rwt.code
  end
end
