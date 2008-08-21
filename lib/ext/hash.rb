#
#  ExtLib - (c) accesstecnologia.com.br
#
#  Hash, with render capabilities for JSON
#  Basic javascript generator dictionaries
#  Generates:
#   prologue
#   item1: item1value, item2: item2value, ...
#   epilogue
# 
#  Revisions:
#   01/05/08, smb, initial version
#   15/05/08, smb, refactored
#

class Hash
  def render  # returns the redered javascript
    if block_given?
      yield self
    end

    js= Ext::Debug.indent+prologue+Ext::Debug.lf
    
    js<< Ext::fillHash(self)
    
    js<< Ext::Debug.indent+epilogue
  end

  def prologue
    @prologue || '{'
  end

  def epilogue
    @epilogue || '}'
  end
end