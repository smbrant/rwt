#
#  ExtLib - Copyright (c) 2008 accesstecnologia.com.br
#
#  Ruby code to interface with the ExtJs javascript library
# 
#  Revisions:
#   01/05/08, smb, initial version
#   15/05/08, smb, refactored & commented
#
require 'ext/util'
require 'ext/dict'
require 'ext/hash'

require 'ext/list'
require 'ext/array'

require 'ext/mix'

require 'ext/menu'
require 'ext/grid'
require 'ext/data'
require 'ext/form'
require 'ext/msg'

module Ext
  
  #
  #  A Button.
  #  
  #  Main attributes:
  #  :text => Button text
  #  :handler => javascript handler (a function)
  #
  class Button < Dict;def prologue;'new Ext.Button({' end;def epilogue;'})' end end

  #
  #  A Component
  #  
  #  Main attributes:
  #  :xtype => component xtype, e.g., 'box', 'button', 'toolbar', etc.
  #
  class Component < Dict
    def prologue
      'new Ext.Component({'
    end
    def epilogue
      '})'
    end
    def render
      raise "Should define the xtype" if !@config[:xtype]
      super
    end
  end

  #
  #  A Panel
  #  
  #  Main attributes:
  #  :items => list of items to be put inside the panel
  #
  class FormPanel < Dict;def prologue;'new Ext.FormPanel({' end;def epilogue;'})' end end

  #
  #  A Toolbar
  #  
  #  Main attributes:
  #  :items => A MixedCollection of this Toolbar's items
  #
  class PagingToolbar < Dict;def prologue;'new Ext.PagingToolbar({' end;def epilogue;'})' end end

  class Panel < Dict;def prologue;'new Ext.Panel({' end;def epilogue;'})' end end
  
  #
  #  A TabPanel
  #  
  #  Main attributes:
  #
  class TabPanel < Dict;def prologue;'new Ext.TabPanel({' end;def epilogue;'})' end end
  
  #
  #  A Window
  #  
  #  Main attributes:
  #  :show => true/false, if true generates a call to the show() method
  #
  class Window < Dict
    def initialize(config=nil)
      super(config)
      @config[:width] || @config[:width]= 300
      @config[:height] || @config[:height]= 200
      @show= true
    end

    def prologue
      if @config.key?(:show) 
        @show= @config[:show]
        @config.delete(:show)
      end
      "new Ext.Window({"
    end
    def epilogue
      if @show
        "}).show();"
      else  
        "})"
      end
    end
  end 

  class XTemplate
    def initialize(*code)
      @code= code
    end
    def prologue
      'new Ext.XTemplate('
    end
    def epilogue
      ')'
    end
    def render
      js=prologue
      i=0
      @code.each do |c|
        i+=1
        if c.respond_to?('render')
          js<< "'" << c.render << "'"
        else
          js<< "'" << c << "'"
        end
        if i < @code.length
          js << ','
        end
      end
      return js+epilogue
    end
  end


  # TODO: complete with the other classes...
  
end