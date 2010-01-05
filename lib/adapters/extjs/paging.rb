module Rwt
  class PagingToolbar
    def render_create
      Rwt << "var #{self}=new Ext.PagingToolbar(#{@config.render});"
      generate_events
    end

  end
end
