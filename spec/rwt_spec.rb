require 'rwt'
include Rwt

RAILS_ROOT= File.dirname(__FILE__)

describe Rwt do
  before(:each) do
#    @rwt = Rwt.new
    Rwt.clear
  end

#  it "should have a clean code buffer in the begining" do
#    Rwt.code.should be_empty
#  end
#
#  it "should have code buffer filled by add_code" do
#    Rwt << "alert('test');"
#    Rwt << "alert('test2');"
#    Rwt.code.should_not be_empty
#    Rwt.code.should == "alert('test');alert('test2');"
#  end
#
#  it "should render javascript views" do
#    # simulating a js view (test_action_js.js file)
#    def params
#      {:controller=>'test_contr',:action=>'test_action_js'}
#    end
#    def render(config={})
#      config[:text]
#    end
#    def render_to_string(config={})
#      config[:inline]
#    end
#
#    rwt_render
#    Rwt.code.should include('function(')
#    Rwt.code.should include("alert('xxxx');")  # see test_action_js.js file
#    Rwt.code.should include('})')
#  end

#  it "should render ruby views" do
#    # simulating a rb view (test_action_rb.rb file)
#    def params
#      {:controller=>'test_contr',:action=>'test_action_rb'}
#    end
#    def render(config={})  # dummy render
#    end
#
#    rwt_render
#    Rwt.code.should include('function(')
#    Rwt.code.should include('})()')
#    puts Rwt.code
#  end

#  it "should load and execute a javascript view with js_load" do
#    # simulating a js view (test_action_js.js file)
#    def params
#      {:controller=>'test_contr',:action=>'test_js_load'}
#    end
#    def render_to_string(config={})
#      config[:inline]
#    end
#    @local_var='test'
#    Rwt.clear
#    1.upto(2) do |x|
#      js_load('test_js_load')
#    end
#    Rwt.code.should include("alert(<%=@local_var%>);")
##    puts Rwt.code
#  end
#
#  it "should load the javascript gui adapter" do
#    Rwt.load_adapter(:adapter=>'extjs')
#    Rwt.adapter.should == 'extjs'
##    Rwt.load_adapter(:adapter=>'dojo')
##    Rwt.adapter.should == 'dojo'
#  end
#
#  it "should render rwt views" do
#
#  end

  it "should include a local file with component hierarchy" do
    @teste='sssss'
#    require File.join(File.dirname(__FILE__),'tx')
    eval(File.open(File.join(File.dirname(__FILE__),'tx.rb')).read)
#    Rwt.code.should include("new Ext.Component")
  end
end

