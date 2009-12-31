module Rwt
  class Data
    def render_create
      @config.merge!(:items=>@components) if @components.length > 0
      Rwt << "var #{self}=new Ext.data.Field(#{@config.render});"
      generate_events
    end
  end
end
