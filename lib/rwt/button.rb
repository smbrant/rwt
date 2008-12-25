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
  #    w << button('button1') do |b|
  #      b.on_click= message('button clicked!')
  #    end
  #    w.show
  #  end
  #     
  def button(*config,&block)
    Button.new(*config,&block)
  end
  class Button<Rwt::Component

    def init_cmp
      @config[:text]= @config[:id] unless @config[:text]
      @on_click= @config.delete(:on_click)
    end

    # Events:
    def on_click(&block)
      @on_click= block
    end

  end 
end

