require 'rwt'
include Rwt

describe Button do
  before(:each) do
    Rwt.clear
  end

  it "should generate a button in the code buffer" do
    x=button('test button') do |b|
      b.text= 'xxx'
    end
    x.text='yyy'
#    puts Rwt.code
  end
end

