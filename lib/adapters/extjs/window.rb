module Rwt
  class Window
    def render_create
      @config.merge!(:items=>@components) if @components.length > 0
      @config.merge!(:title=>@title,:x=>@x,:y=>@y)

      Rwt << "var #{@config[:id]}=new Ext.Window(#{@config.render});"
      Rwt << "#{@config[:id]}.show();" if @visible
    end

    def show
      Rwt << "#{self}.show();"
    end
    def close
      Rwt << "#{self}.close();"
    end

  end
end
