#
#  ExtLib (c) accesstecnologia.com.br
# 
#  Ext::Mix
#  Basic javascript generator for mix of hashs and/or arrays
#  
#  Generates:
#   prologue
#   {item1: value1, item2: value2,...},[item1value, item2value, ...
#   epilogue
# 
#  Revisions:
#   30/04/08, smb, initial version
#   15/05/08, smb, refactored
#
module Ext
  class Mix
    def initialize(*config)
      @mixConf= config
    end

    def render  # returns the redered javascript

      js= Ext::Debug.indent+prologue+Ext::Debug.lf
      Ext::Debug.incr_indent

      nItems= @mixConf.length
      item=0
      @mixConf.each do |config|
        item+=1
        case config
          when Hash
            js<< Ext::Debug.indent+'{'+Ext::Debug.lf
            js<< Ext::fillHash(config)
            js<< Ext::Debug.indent+'}'+Ext::Debug.lf
          when Array
            js<< Ext::Debug.indent+'['+Ext::Debug.lf
            js<< Ext::fillArray(config)
            js<< Ext::Debug.indent+']'+Ext::Debug.lf
          else
            raise "Parameters should be Arrays or Hashs." 
        end
        if item < nItems then 
          js<<','
        end
        js<<Ext::Debug.lf
      end
      
      Ext::Debug.decr_indent
      js<< Ext::Debug.indent+epilogue

    end

    def prologue
      @prologue || '('
    end
    def epilogue
      @epilogue || ')'
    end

  end

end
