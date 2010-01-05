module Rwt
  def column(*config,&block)
    Column.new(*config,&block)
  end

  class Column < Rwt::Component
    def init_default_par(non_hash_params)
       @config[:dataIndex]=non_hash_params[0] if non_hash_params[0].class == String
       @config[:header]=non_hash_params[1] if non_hash_params[1].class == String
    end
    def init_cmp
      @config[:header]= @config[:dataIndex].capitalize unless @config[:header]
    end
  end
end
