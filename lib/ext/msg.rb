module Ext
  module Msg

    def self.confirm(title,msg,fn=nil,scope=nil,multiline=false,value='')
      JS.new("Ext.Msg.confirm('#{title}','#{msg}'",
        if fn
          JS.new(",",fn)
        end,
        ")")
    end

    def self.prompt(title,msg,fn=nil,scope=nil,multiline=false,value='')
      JS.new("Ext.Msg.prompt('#{title}','#{msg}'",
        if fn
          JS.new(",",fn)
        end,
        ")")
    end
    
    def self.show(config)
      js('Ext.Msg.show(',config,')')
    end

  end
end