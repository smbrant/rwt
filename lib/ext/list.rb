#
#  ExtLib - (c) accesstecnologia.com.br
#
#  Ext::List
#  Basic javascript generator for array lists
#  
#  Generates:
#   prologue
#   item1value, item2value, ...
#   epilogue
# 
#  Revisions:
#   01/05/08, smb, initial version
#   15/05/08, smb, refactored
#
module Ext
  class List
    def initialize(config=nil)
      case config
        when String
          @prologue= config
          @config= []
        when Array
          @config= config
        when NilClass
          @config= []
        else
          @config= [config]
      end
      if block_given?
        yield self
      end
    end

    def <<(config)
      case config
        when Array
          @config+= config
        else
          @config << config
      end
    end

    def render  # returns the redered javascript
      if block_given?
        yield self
      end

      js= Ext::Debug.indent+prologue+Ext::Debug.lf
      
      js<< Ext::fillArray(@config)
      
      js<< Ext::Debug.indent+epilogue
    end

    def prologue
      @prologue || '['
    end
    def epilogue
      @epilogue || ']'
    end

  end
end
