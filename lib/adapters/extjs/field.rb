module Rwt
  FIELDTYPE={
    'datefield'=>'DateField',
    'textfield'=>'TextField',
    'checkbox'=>'Checkbox',
    'combo'=>'ComboBox',
    'field'=>'Field',
    'fieldset'=>'FieldSet',
    'hidden'=>'Hidden',
    'htmleditor'=>'HtmlEditor',
    'label'=>'Label',
    'numberfield'=>'NumberField',
    'radio'=>'Radio',
    'textarea'=>'TextArea',
    'timefield'=>'TimeField',
    'trigger'=>'TriggerField'
  }
  class Field
    def render_create
      @config.merge!(:items=>@components) if @components.length > 0
#      Rwt << "var #{self}=#{@config.render};"
#      Rwt << "var #{self}=new Ext.form.Field(#{@config.render});"
      Rwt << "var #{self}=new Ext.form.#{FIELDTYPE[@config[:xtype]]}(#{@config.render});"
      generate_default_events
    end
  end
end
