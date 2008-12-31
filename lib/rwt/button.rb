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
  #  Use
  #  ===
  #  
  #  window(:title=>'Test Window') do |w|
  #    w << button('button1') do |b|
  #      b.on('click'){ message('button clicked!')}
  #    end
  #  end
  #     
  def button(*config,&block)
    Button.new(*config,&block)
  end
  class Button<Rwt::Component

    def init_cmp
      @config[:text]= @config[:v] unless @config[:text]
#      @on_click= @config.delete(:on_click)
    end

    # Events:
#    def on_click(&block)
#      @on_click= block
#    end

  end 
end

