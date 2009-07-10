module Rwt
  class Component
    def render_create
      # Include components as items in extjs component
      @config.merge!(:items=>@components) if @components.length > 0

      # Render dojo code
      "dojo code for component to be done..."
#      "var #{@config[:v]}=new Ext.Component(#{@config.render});"
    end
  end
end
