#
#  ExtLib - (c) accesstecnologia.com.br
#
#  Ext::Data module, equivalent to Ext.data javascript package
#  
#  Revisions:
#   01/05/08, smb, initial version
#
module Ext
  module Data

    class JsonReader < Mix;def prologue;'new Ext.data.JsonReader(' end;def epilogue;')' end end

    class JsonStore < Dict;def prologue;'new Ext.data.JsonStore({' end;def epilogue;'})' end end
    
    class HttpProxy < Dict;def prologue;'new Ext.data.HttpProxy({' end;def epilogue;'})' end end
    
    class ScriptTagProxy < Dict;def prologue;'new Ext.data.ScriptTagProxy({' end;def epilogue; '})' end end

    class Store < Dict;def prologue;'new Ext.data.Store({' end;def epilogue; '})' end end

    class SimpleStore < Dict;def prologue;'new Ext.data.SimpleStore({' end;def epilogue; '})' end end

  end
end