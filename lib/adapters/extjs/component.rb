module Rwt
  class Component
    def render_create
      # Include components as items in extjs component
      @config.merge!(:items=>@components) if @components.length > 0

      # Render extjs code
      Rwt << "var #{self}=new Ext.Component(#{@config.render});"

      generate_default_events

    end

    def generate_event(event,block)
      Rwt << "#{self}.on('#{event}',function(){"
      block.call
      Rwt << "});"
    end

    def generate_default_events
      # The rwt on_create event
      @on_create.call if @on_create

      # The other extjs events:
      @event.each do |evt,block|
        Rwt << "#{self}.on('#{evt}',function("
        Rwt << @event_params[evt].join(',')
        Rwt << "){"
        block.call
        Rwt << "});"
      end
    end
  end
end
