require 'rwt'
include Rwt

describe Toolbar do
  before(:each) do
    Rwt.clear
  end

  it "should generate a toolbar with menus" do
    toolbar do
      text("text1")
      menu("menu1") do
        menu_item('xxx',"function(){alert('x')}")
      end
    end
#    puts Rwt.code
  end
end

