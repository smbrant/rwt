module Rwt
  def tabpanel(*config,&block)
    TabPanel.new(*config,&block)
  end
  
  class TabPanel < Rwt::Component
  end 
end
