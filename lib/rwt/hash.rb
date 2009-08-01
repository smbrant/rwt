#
#  Rwt - (c) access.srv.br
#
#  Array, with render capabilities for the equivalent javascript
#  Basic javascript generator for hash dictionaries
#
#  Generates:
#   prologue
#   item1:item1value,item2:item2value, ...
#   epilogue
#
#  Revisions:
#   smb, may 01 2008, initial version
#   smb, dec 06 2008, refactored
#
class Hash
  def render  # returns the redered javascript
    if block_given?
      yield self
    end
    prologue + fill_hash(self) + epilogue
  end

  def prologue
    @prologue || '{'
  end

  def epilogue
    @epilogue || '}'
  end
end