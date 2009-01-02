module Rwt
  def fieldset(*config,&block)
    FieldSet.new(*config,&block)
  end
  class FieldSet<Rwt::Component

    def init_default_par(non_hash_params)
       @config[:title]=non_hash_params[0] if non_hash_params[0].class == String
    end

    def init_cmp
    end

  end 
end

