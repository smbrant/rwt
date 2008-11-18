module Rwt
  #
  #  Rwt::Button
  #  ===========
  #
  #  Config parameters:
  #  ==================
  #  
  #  text -     Button caption, defaults to component id.
  #     
  #  on_click - Function to be executed when the button is clicked.
  #     
  #  Use
  #  ===
  #  
  #  window(:title=>'Test Window') do |w|
  #    w << button(:text=>'button1') do |b|
  #      b.on_click= message('button clicked!')
  #    end
  #    w.show
  #  end
  #     
  def button(*config,&block)
    Button.new(*config,&block)
  end
  class Button<Rwt::Component
    attr_accessor :text
    attr_accessor :on_click

    def init_cmp
      @text= @config.delete(:text) || @config[:id]
      @on_click= @config.delete(:on_click)
    end
    
    def render
      listeners=@config.delete(:listeners) || {}
      listeners.merge!(:click=>@on_click) if @on_click
      @config.merge!(:listeners=>listeners)
      @config.merge!(:text=>@text,:xtype=>'button')
      
      @config.render # Let Ext treat this
    end

  end 
end