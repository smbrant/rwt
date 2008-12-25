#
#  Rwt - (c) accesstecnologia.com.br
#
#  Array, with render capabilities for the equivalent javascript
#  Basic javascript generator for array lists
#
#  Generates:
#    prologue
#    item1value,item2value, ...
#    epilogue
#
#  Revisions:
#   smb, may 01 2008, initial version
#   smb, dec 06 2008, refactored
#
class Array

  def render  # returns the redered javascript
    if block_given?
      yield self
    end
    prologue + fill_array(self) + epilogue
  end

  def prologue
    @prologue || '['
  end
  def epilogue
    @epilogue || ']'
  end
end
