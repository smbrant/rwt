module Rwt
  class Component
    def render_create
      # Include components as items in extjs component
      @config.merge!(:items=>@components) if @components.length > 0

      # Render extjs code
      Rwt << "var #{@config[:v]}=new Ext.Component(#{@config.render});"
    end

    def generate_event(event,block)
      Rwt << "#{@config[:v]}.on('#{event}',function(){"
      block.call
      Rwt << "});"
    end
  end
end
