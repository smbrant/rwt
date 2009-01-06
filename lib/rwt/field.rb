module Rwt
  #
  #  Rwt::Field
  #  ==========
  #
  #  Config parameters:
  #  ==================
  #
  #  name [[fieldLabel] :xtype]
  #  
  def field(*config,&block)
    Field.new(*config,&block)
  end
  class Field<Rwt::Component

    def init_default_par(non_hash_params)
       @config[:name]= non_hash_params[0] if non_hash_params[0].class == String
       if non_hash_params[1] then
         if non_hash_params[1].class == String then
           @config[:fieldLabel]=non_hash_params[1]
         elsif non_hash_params[1].class == Symbol then
           @config[:xtype]= non_hash_params[1].to_s
         end
       end
       @config[:xtype]= non_hash_params[2].to_s if non_hash_params[2]
       @config[:fieldLabel]= @config[:name].capitalize unless @config[:fieldLabel]
    end

    def init_cmp
      @config[:xtype]= 'textfield' unless @config[:xtype]
      if owner.is_a?(Rwt::EditForm)
        model_name= owner.config[:model_data].class.name.underscore.downcase
        @config[:name]="#{model_name}[#{@config[:name]}]"
      end
    end

  end 
end

