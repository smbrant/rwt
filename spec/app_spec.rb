require 'rwt'
include Rwt

describe App do
  before(:each) do
    Rwt.clear
  end

  it "should generate a complete application" do
#    Rwt.load_adapter(:adapter=>'dojo')
    rwt_app do |app|
      1.upto(3) do |x|
        component("component#{x}")
      end
    end
    Rwt.code.should include("text:'component1")
    Rwt.code.should include("text:'component2")
    Rwt.code.should include("text:'component3")
#    puts Rwt.code
  end

  it "should be able to include a toolbar" do
    rwt_app do
      toolbar
    end
#    puts Rwt.code
    Rwt.code.should include("Ext.Toolbar")
  end

end

