module Rwt
  class Button < Rwt::Component
    def render_create
#      listeners=@config.delete(:listeners) || {}
#      listeners.merge!(:click=>@on_click) if @on_click
#      @config.merge!(:listeners=>listeners) if listeners.length > 0

      Rwt << "var #{self}=new Ext.Button(#{@config.render});"
#      generate_event('click',@on_click) if @on_click

      generate_default_events

    end

    def text=(value)
      @config[:text]=value
      Rwt << "#{self}.setText('#{value}');"
    end

  end
end