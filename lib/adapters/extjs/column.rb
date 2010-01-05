module Rwt
  class Column
    def render_create
      Rwt << "var #{self}=new Ext.grid.Column(#{@config.render});"
      generate_events
    end

  end
end
