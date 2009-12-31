module Rwt
  #
  #  Rwt::JsonStore
  #  ==============
  #
  #  Config parameters:
  #  ==================
  #
  #
  def jsonstore(*config,&block)
    JsonStore.new(*config,&block)
  end

  class JsonStore<Rwt::Component
    def init_default_par(non_hash_params)
       @config[:url]=non_hash_params[0] if non_hash_params[0].class == String
    end
  end
end