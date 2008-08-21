require 'rwt/component'
module Rwt
  #
  #  Rwt::Toolbar
  #  ============
  #
  #  Config parameters:
  #  ==================
  #  
  #  place -    A place (div id) where to insert the toolbar.
  #     
  #  Use
  #  ===
  #  
  #  A toolbar can be inserted in an application or in a window. In a application
  #  it is common to indicate a place (a element id, e.g. a div id) where the 
  #  toolbar should be inserted. In a window the position will be given by the 
  #  component's visual hierarchy.
  #  
  #  In an application:
  #  
  #  rwt_app do |app|
  #    app << toolbar(:place=>'header') do |tb|
  #      tb << {:text=>'test',
  #             :menu=>{:items=>[
  #                        {:text=>'A mensage',:handler=>message('test1')},
  #                        {:text=>'An other window',:handler=>call_view('/test/app1_test2')},
  #                    ]}
  #             }
  #    end
  #  end
  #  
  #  In a window:
  #  
  #  window(:title=>'Test Window') do |w|
  #    w << toolbar do |tb|
  #      tb << {:text=>'test',
  #             :menu=>{:items=>[
  #                        {:text=>'A mensage',:handler=>message('test1')},
  #                        {:text=>'An other window',:handler=>call_view('/test/app1_test2')},
  #                    ]}
  #             }
  #    end
  #  end
  #  
  def toolbar(config={},&block)
    Toolbar.new(config,&block)
  end
  class Toolbar < Rwt::Component

    def init_cmp
      @place= @config.delete(:place)
    end

    def render
      if @owner.class == Rwt::App || @owner.class == NilClass
        program(
          js("var tb=new Ext.Toolbar({items:",@components,"});",
              if @place
                "if(!Ext.get('#{@place}')){"+
                  'var div=document.createElement("div");'+
                  "div.setAttribute('id','#{@place}');"+
                  'document.getElementsByTagName("body")[0].appendChild(div)'+
                '}'+
                "tb.render('#{@place}');"
              else
                "if (owner==Rwt){tb.render(document.body)}"
              end,
              "if(!owner.tb){owner.tb=tb}"
            ).render
          ).render
      else
        {:xtype=>'toolbar',:items=>@components}.render
      end
    end
    
  end 
end