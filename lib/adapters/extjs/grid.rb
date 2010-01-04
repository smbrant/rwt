module Rwt
  class Grid
    def render_create
      Rwt << "var #{self}=new Ext.grid.GridPanel(#{@config.render});"
      generate_events
    end

  end
end
