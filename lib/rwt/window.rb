module Rwt
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
  #  Any other parameter will be passed directly to the javascript library.
  #
  #  Properties:
  #  ===========
  #
  #  title, x, y
  #
  #  Use
  #  ===
  #
  #  window('Test Window') do |w|
  #    button('button1') do |b|
  #      b.on('click') do
  #        message('button clicked!')
  #      end
  #    end
  #    w.on('close) do
  #      message('closed')
  #    end
  #  end
  #
  def window(*config,&block)
    Window.new(*config,&block)
  end
  
  class Window < Rwt::Component
    @@x= 40
    @@y= 40

    attr_accessor :x,:y 
    attr_accessor :title
    attr_accessor :visible

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
      @x= @config.delete(:x) || Window.new_x
      @y= @config.delete(:y) || Window.new_y
      @title= @config.delete(:title) || @config[:v]
      @visible= if @config.key?(:visible)
            @config[:visible]
          else
            true
          end
    end
    
  end 
end
