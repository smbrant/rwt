require 'rwt'

describe Array do
  before(:each) do
#    @array = Array.new
  end

  it "should have render capabilities" do
    @array= [1,2,3]                           # An array
    @array.render.should include("[1,2,3]")   # A string
  end
end
