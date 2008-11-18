#  Rwt::Window
#  ===========
#  
#  The window component. The basic component container for building gui interfaces.
#  
#  Config parameters:
#  ==================
#  
#  title - window title, defaults to component id
#  x, y  - window position, defaults to next cascading position
#    
#  on_close - function to be executed when the window is closed
#     
#  Any other parameter will be passed directly to Ext.
#  
#  Properties:
#  ===========
#  
#  title, x, y, on_close
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
#  or
#  
#  window('Test Window') do |w|
#    w << button('button1') do |b|
#      b.on_click= message('button clicked!')
#    end
#    w.on_close= message('closed')
#    w.show
#  end
#     

module Rwt
  def window(*config,&block)
    Window.new(*config,&block)
  end
  
  class Window < Rwt::Component
    @@x= 40
    @@y= 40

    attr_accessor :x,:y 
    attr_accessor :title
    attr_accessor :on_close
    attr_accessor :before_render, :after_render # code to be excuted before and after normal render

    def self.new_x
      @@x+= 20; @@x= 40 if @@x > 100
      return @@x
    end

    def self.new_y
      @@y+= 20; @@y= 40 if @@y > 100
      return @@y
    end

    def init_default_par(non_hash_params)
       @config[:title]=non_hash_params[0] if non_hash_params[0].class == String
       @config[:width]= non_hash_params[1] if non_hash_params[1].class == Fixnum
       @config[:height]= non_hash_params[2] if non_hash_params[2].class == Fixnum
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

    def close
      function("Ext.getCmp('#{@config[:id]}').close()")
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

        case @before_render
          when Snippet
            @before_render.render # program snippet
          when Program
            @before_render.render+"()" # render the program and execute it
          when Function
            "("+@before_render.render+")()" # encapsulate and execute it
        end,

        win=var(Ext::Window.new(@config)),
        @show ? win.show() : "",

        case @after_render
          when Snippet
            @after_render.render # program snippet
          when Program
            @after_render.render+"()" # render the program and execute it
          when Function
            "("+@after_render.render+")()" # encapsulate and execute it
        end,

        pass_owner(win)
      ).render
    end

  end 
end