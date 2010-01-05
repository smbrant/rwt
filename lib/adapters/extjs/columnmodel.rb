module Rwt
  class ColumnModel
    def render_create
      @config.merge!(:columns=>@components) if @components.length > 0
      Rwt << "var #{self}=new Ext.grid.ColumnModel(#{@config.render});"
      generate_events
    end

  end
end
