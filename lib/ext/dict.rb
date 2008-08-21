#
#  ExtLib - (c) accesstecnologia.com.br
#
#  Hash, with render capabilities for JSON
#  Basic javascript generator for hashs
#  Generates:
#    prologue
#    item1: item1value, item2: item2value, ...
#    epilogue
# 
#  Revisions:
#   01/05/08, smb, initial version
#   15/05/08, smb, refactored
#
module Ext
  class Dict
    def initialize(config=nil,epilogue=nil)
      case config
        when String
          @prologue= config
          @config= {}
        when Hash
          @config= config
        when NilClass
          @config={}
        else
          @config={}
      end
      @epilogue= epilogue
      @proc_before_render= nil
      @proc_after_render= nil
      if block_given?
        yield self
      end
    end

    def <<(config)
      case config
        when Hash
          @config.merge!(config)
        else
          @config.merge!({:undefined=>config})
      end
    end

    # Convert unexpected method calls to attribute values in config
    def method_missing(*args,&block)
      m= args.shift
      return @config[m]||nil
    end
    
    def render  # returns the redered javascript
      if block_given?
        yield self
      end

      if @proc_before_render
        js= @proc_before_render.call()
        if js.respond_to?('render')
          js= js.render
        end
      else
        js= ''
      end
      
      js<< Ext::Debug.indent+prologue+Ext::Debug.lf
      
      js<< Ext::fillHash(@config)

      js<< Ext::Debug.indent+epilogue

      if @proc_after_render
        rest= @proc_after_render.call()
        if rest.respond_to?('render')
          js<< rest.render
        else
          js << rest
        end
      end
      return js
    end

    def prologue
      @prologue || '{'
    end
    def epilogue
      @epilogue || '}'
    end
    
    def before_render(&proc)
      if block_given?
        @proc_before_render= proc # save the block passed
        yield self
      else
        @proc_before_render= nil
      end
    end

    def after_render(&proc)
      if block_given?
        @proc_after_render= proc # save the block passed
        yield self
      else
        @proc_after_render= nil
      end
    end

  end

end
