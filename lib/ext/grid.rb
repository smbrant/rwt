#
#  ExtLib - (c) accesstecnologia.com.br
#
#  Ext::Grid module, equivalent to Ext.grid javascript package
#  
#  Revisions:
#   01/05/08, smb, initial version
#   15/05/08, smb, refactored
#
module Ext
  module Grid
    class GridPanel < Dict ; def prologue;"new Ext.grid.GridPanel({" end;def epilogue;"})" end end
    
    class CheckColumn < List ; def prologue;"new Ext.grid.CheckColumn({" end;def epilogue;"})" end end
    
    class ColumnModel < Mix ; def prologue;'new Ext.grid.ColumnModel([' end;def epilogue;'])' end end
    
    class RowSelectionModel < Dict ; def prologue;'new Ext.grid.RowSelectionModel({' end;def epilogue;'})' end end

    # TODO: complete code...
  end
end

