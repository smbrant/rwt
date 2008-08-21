#
#  ExtLib - (c) accesstecnologia.com.br
#
#  Ext::Form module, equivalent to Ext.form javascript package
#  
#  Revisions:
#   01/05/08, smb, initial version
#   15/05/08, smb, refactored
#
module Ext
  module Form

    class BasicForm < Dict ;def prologue;'new Ext.form.BasicForm({' end;def epilogue;'})' end end

    class ComboBox < Dict ;def prologue;'new Ext.form.ComboBox({' end;def epilogue;'})' end end

    class FieldSet < Dict ;def prologue;'new Ext.form.FieldSet({' end;def epilogue;'})' end end

    class Label < Dict ;def prologue;'new Ext.form.Label({' end;def epilogue;'})' end end

    class TextField < Dict ;def prologue;'new Ext.form.TextField({' end;def epilogue;'})' end end

    class TimeField < Dict ;def prologue;'new Ext.form.TimeField({' end;def epilogue;'})' end end

  end
end