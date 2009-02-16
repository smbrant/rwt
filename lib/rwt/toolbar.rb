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
  def toolbar(*config,&block)
    Toolbar.new(self,*config,&block)
  end
  class Toolbar < Rwt::Component

    def init_cmp
      @place= @config.delete(:place)
    end

    def render_create
      "/* #{Rwt.adapter} adapter should create a toolbar here - fix it */"
    end
    
  end
  

  def text(*config,&block)
    Text.new(*config,&block)
  end
  class Text < Rwt::Component
    def render_create
      "/* #{Rwt.adapter} adapter should create a text here - fix it */"
    end
  end
  
  def menu(*config,&block)
    Menu.new(*config,&block)
  end
  class Menu < Rwt::Component
    def render_create
      "/* #{Rwt.adapter} adapter should create a menu here - fix it */"
    end
  end
  
  
  #
  # MenuItem
  # 
  # Parameters:
  # 
  # Default parameter order:
  # text, handler
  #
  def menu_item(*config,&block)
    MenuItem.new(*config,&block)
  end
  class MenuItem < Rwt::Component
    def init_default_par(non_hash_params)
       @config[:text]=non_hash_params[0] if non_hash_params[0].class == String
       @config[:handler]= non_hash_params[1] if non_hash_params[1]
    end

    def render_create
      "/* #{Rwt.adapter} adapter should create a menu here - fix it */"
    end
  end
end
