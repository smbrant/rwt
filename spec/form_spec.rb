require 'rwt'
include Rwt

describe Form do
  before(:each) do
    Rwt.clear
  end

  it "should generate a form in the code buffer" do
    form
#    puts Rwt.code
    Rwt.code.should include("height:'auto'")
    Rwt.code.should include("listeners:{actioncomplete:function(form,action)")
  end

  it "should generate a submit if asked for" do
    form('/test') do |f|
      button(:handler=>f.submit)
    end
#    puts Rwt.code
  end
  
end

