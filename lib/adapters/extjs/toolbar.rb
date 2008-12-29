module Rwt
  class Toolbar
    def render_create
      @config.merge!(:items=>@components) if @components.length > 0
      if @owner.class == Rwt::App || @owner.class == NilClass
        Rwt << "var tb=new Ext.Toolbar(#{@config.render});"
        if @place
          Rwt << "if(!Ext.get('#{@place}')){"+
            'var div=document.createElement("div");'+
            "div.setAttribute('id','#{@place}');"+
            'document.getElementsByTagName("body")[0].appendChild(div)'+
          '}'+
          "tb.render('#{@place}');"
        else
          Rwt << "if (owner==Rwt){tb.render(document.body)}"
        end
        Rwt << "if(!owner.tb){owner.tb=tb}"
      else
        Rwt << {:xtype=>'toolbar',:items=>@components}.render
      end
    end
  end

  class Text < Component
    def render_create
      if @owner.class == Toolbar     # inside a toolbar whe should use tbtext
        @config.merge!(:xtype=>'tbtext')
      end
      Rwt << "var #{@config[:v]}=#{@config.render};"
    end
  end

  class Menu < Component
    def render_create
      Rwt << "var #{@config[:v]}=#{@config.merge(:menu=>@components).render};"
    end
  end

  class MenuItem < Component
    def render_create
      @config.merge!(:items=>@components) if @components.length > 0
      Rwt << "var #{@config[:v]}=#{@config.render};"
    end
  end

end
