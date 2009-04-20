# To change this template, choose Tools | Templates
# and open the template in the editor.

require "i18n"

describe I18n do
  before(:each) do
    I18n.locale= :en
  end

  it "should translate" do
    I18n.t('rwt.adapter.should_generate_code',:adapter=>'test').should include("/* test adapter should generate code to call a view - fix it */")
  end
end

