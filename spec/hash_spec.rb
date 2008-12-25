require 'rwt'

describe Hash do
  before(:each) do
#    @hash = Hash.new
  end

  it "should have render capabilities" do
    @hash= {:a=>1,:b=>2,:c=>3}          # A hash
    @hash.render.should include("a:1")  # Strings in any order
    @hash.render.should include("b:2")  # Strings
    @hash.render.should include("c:3")  # Strings
    @hash.render.should include("{")   # The start
    @hash.render.should include("}")    # The end
  end
end

