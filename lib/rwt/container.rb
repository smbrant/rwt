module Rwt
  #
  #  Rwt::Container
  #  ==============
  #
  #  Config parameters:
  #  ==================
  #  
  #     
  def container(*config,&block)
    Container.new(*config,&block)
  end
  
  class Container<Rwt::Component
  end 
end

