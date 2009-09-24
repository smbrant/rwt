module Rwt
  class Container < Rwt::Component
    def render_create
      @config.merge!(:items=>@components) if @components.length > 0
      Rwt << "var #{self}=new Ext.Container(#{@config.render});"
      generate_events
    end

  end
end