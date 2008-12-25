module Rwt
  class Component
    def render_create
      # Include components as items in extjs component
      @config.merge!(:items=>@components) if @components.length > 0

      # Render extjs code
      "var #{@config[:id]}=new Ext.Component(#{@config.render});"
    end
  end
end
