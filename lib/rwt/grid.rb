#  Rwt::Grid
#  =========
#  
#  The grid component.
#  
#  Config parameters:
#  ==================
#  
#  Properties:
#  ===========
#     
#  Any other parameter will be passed directly to Ext.
#  
#  Use
#  ===
#     
#  window(:title=>'Test Window') do |w|
#    w << grid() do |g|
#    end
#    w.show
#  end
#     
module Rwt
  def grid(*config,&block)
    Grid.new(*config,&block)
  end
  
  class Grid < Component
    attr_accessor :cm,:ds


    def init_default_par(non_hash_params)
#       @config[:title]=non_hash_params[0] if non_hash_params[0].class == String
#       @config[:width]= non_hash_params[1] if non_hash_params[1].class == Fixnum
#       @config[:height]= non_hash_params[2] if non_hash_params[2].class == Fixnum
    end
    
    def init_cmp
    end
    
    def render
#      listeners=@config.delete(:listeners) || {}
#      listeners.merge!(:close=>@on_close) if @on_close
#      @config.merge!(:listeners=>listeners)
      if @components.length > 0
        @config.merge!(:columns=>@components)
      end
#      @config.merge!(:title=>@title,:show=>false,:x=>@x,:y=>@y)

#      @config.merge!(:xtype=>'grid')
#      @config.render

      Ext::Grid::GridPanel.new(@config).render
      
    end

  end 
end