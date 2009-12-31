module Rwt
  #
  #  Rwt::Data
  #  ==========
  #
  #  Config parameters:
  #  ==================
  #
  #
  def data(*config,&block)
    Data.new(*config,&block)
  end
  class Data<Rwt::Component

    def init_default_par(non_hash_params)
       @config[:name]=non_hash_params[0] if non_hash_params[0].class == String
       @config[:type]= non_hash_params[1] if non_hash_params[1].class == String
    end

  end
end

