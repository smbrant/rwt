module Rwt
  class Field
    def render_create
      @config.merge!(:items=>@components) if @components.length > 0
      Rwt << "var #{self}=#{@config.render};"

      generate_default_events
    end
  end
end
