module Rwt
  #
  #  Rwt::Panel
  #  ==========
  #
  #  Config parameters:
  #  ==================
  #  
  #     
  def panel(*config,&block)
    Panel.new(*config,&block)
  end
  
  class Panel<Rwt::Component
  end 
end

