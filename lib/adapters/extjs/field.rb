module Rwt
  class Field
    def render_create
      @config.merge!(:items=>@components) if @components.length > 0
      Rwt << "var #{@config[:v]}=#{@config.render};"
    end
  end
end
