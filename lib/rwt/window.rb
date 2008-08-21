#  Rwt::Window
#  ===========
#  
#  The window component. The basic component container for building gui interfaces.
#  
#  Config parameters/properties:
#  =============================
#  
#  title - window title, defaults to component id
#  x, y  - window position, defaults to next cascading position
#    
#  on_close - function to be executed when the window is closed
#     
#  Any other parameter will be passed directly to Ext.
#  
#  Use
#  ===
#     
#  window(:title=>'Test Window') do |w|
#    w << button(:text=>'button1') do |b|
#      b.on_click= message('button clicked!')
#    end
#    w.on_close= message('closed')
#    w.show
#  end
#     
module Rwt
  def window(config={},&block)
    Window.new(config,&block)
  end
  
  class Window<Rwt::Component
    @@x= 40
    @@y= 40

    attr_accessor :x,:y 
    attr_accessor :title
    attr_accessor :on_close

    def self.new_x
      @@x+= 20; @@x= 40 if @@x > 400
      return @@x
    end

    def self.new_y
      @@y+= 20; @@y= 40 if @@y > 400
      return @@y
    end

    def init_cmp
      @show= false
      @x= @config.delete(:x) || Window.new_x
      @y= @config.delete(:y) || Window.new_y
      @title= @config.delete(:title) || @config[:id]
    end
    
    def show
      @show=true
    end

    def render
      listeners=@config.delete(:listeners) || {}
      listeners.merge!(:close=>@on_close) if @on_close
      @config.merge!(:listeners=>listeners)
      if @components.length > 0
        @config.merge!(:items=>@components)
      end
      @config.merge!(:title=>@title,:show=>false,:x=>@x,:y=>@y)
      program(
        prepare_owner,
        win=var(Ext::Window.new(@config)),
        pass_owner(win),
        @show ? win.show() : ""
      ).render
    end

  end 
end