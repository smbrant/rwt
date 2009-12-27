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
    def init_default_par(non_hash_params)
       @config[:title]=non_hash_params[0] if non_hash_params[0].class == String
    end
  end 
end

