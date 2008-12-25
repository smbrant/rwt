module Rwt
  class Button < Component
    def render_create
#      listeners=@config.delete(:listeners) || {}
#      listeners.merge!(:click=>@on_click) if @on_click
#      @config.merge!(:listeners=>listeners) if listeners.length > 0

      Rwt << "var #{@config[:id]}=new Ext.Button(#{@config.render});"
      generate_event('click',@on_click) if @on_click

    end

    def text=(value)
      super
      Rwt << "#{@config[:id]}.setText('#{value}');" if @created
    end

  end
end