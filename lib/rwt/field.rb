module Rwt
  #
  #  Rwt::Field
  #  ==========
  #
  #  Config parameters:
  #  ==================
  #  
  def field(*config,&block)
    Field.new(*config,&block)
  end
  class Field<Rwt::Component

    def init_default_par(non_hash_params)
       @config[:fieldLabel]=non_hash_params[0] if non_hash_params[0].class == String
       @config[:name]= non_hash_params[1] if non_hash_params[1].class == String
       @config[:xtype]= non_hash_params[2] if non_hash_params[2].class == String
    end

    def init_cmp
      @config[:xtype]= 'textfield' unless @config[:xtype]
    end

  end 
end

