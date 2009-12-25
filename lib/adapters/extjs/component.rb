XTYPE_CONSTRUCTOR={
'box'=>              'Ext.BoxComponent',
'button'=>           'Ext.Button',
'buttongroup'=>      'Ext.ButtonGroup',
'colorpalette'=>     'Ext.ColorPalette',
'component'=>        'Ext.Component',
'container'=>        'Ext.Container',
'cycle'=>            'Ext.CycleButton',
'dataview'=>         'Ext.DataView',
'datepicker'=>       'Ext.DatePicker',
'editor'    =>       'Ext.Editor',
'editorgrid'=>       'Ext.grid.EditorGridPanel',
'flash'     =>       'Ext.FlashComponent',
'grid'      =>       'Ext.grid.GridPanel',
'listview'  =>       'Ext.ListView',
'panel'     =>       'Ext.Panel',
'progress'  =>       'Ext.ProgressBar',
'propertygrid'=>     'Ext.grid.PropertyGrid',
'slider'      =>     'Ext.Slider',
'spacer'      =>     'Ext.Spacer',
'splitbutton' =>     'Ext.SplitButton',
'tabpanel'    =>     'Ext.TabPanel',
'treepanel'   =>     'Ext.tree.TreePanel',
'viewport'    =>     'Ext.ViewPort',
'window'      =>     'Ext.Window',

#Toolbar components
'paging'          => 'Ext.PagingToolbar',
'toolbar'         => 'Ext.Toolbar',
'tbbutton'        => 'Ext.Toolbar.Button', #        (deprecated; use button)
'tbfill'          => 'Ext.Toolbar.Fill',
'tbitem'          => 'Ext.Toolbar.Item',
'tbseparator'     => 'Ext.Toolbar.Separator',
'tbspacer'        => 'Ext.Toolbar.Spacer',
'tbsplit'         => 'Ext.Toolbar.SplitButton',  # (deprecated; use splitbutton)
'tbtext'          => 'Ext.Toolbar.TextItem',

#Menu components
'menu'            => 'Ext.menu.Menu',
'colormenu'       => 'Ext.menu.ColorMenu',
'datemenu'        => 'Ext.menu.DateMenu',
'menubaseitem'    => 'Ext.menu.BaseItem',
'menucheckitem'   => 'Ext.menu.CheckItem',
'menuitem'        => 'Ext.menu.Item',
'menuseparator'   => 'Ext.menu.Separator',
'menutextitem'    => 'Ext.menu.TextItem',

#Form components
'form'            => 'Ext.form.FormPanel',
'checkbox'        => 'Ext.form.Checkbox',
'checkboxgroup'   => 'Ext.form.CheckboxGroup',
'combo'           => 'Ext.form.ComboBox',
'datefield'       => 'Ext.form.DateField',
'displayfield'    => 'Ext.form.DisplayField',
'field'           => 'Ext.form.Field',
'fieldset'        => 'Ext.form.FieldSet',
'hidden'          => 'Ext.form.Hidden',
'htmleditor'      => 'Ext.form.HtmlEditor',
'label'           => 'Ext.form.Label',
'numberfield'     => 'Ext.form.NumberField',
'radio'           => 'Ext.form.Radio',
'radiogroup'      => 'Ext.form.RadioGroup',
'textarea'        => 'Ext.form.TextArea',
'textfield'       => 'Ext.form.TextField',
'timefield'       => 'Ext.form.TimeField',
'trigger'         => 'Ext.form.TriggerField',

#Chart components
'chart'           => 'Ext.chart.Chart',
'barchart'        => 'Ext.chart.BarChart',
'cartesianchart'  => 'Ext.chart.CartesianChart',
'columnchart'     => 'Ext.chart.ColumnChart',
'linechart'       => 'Ext.chart.LineChart',
'piechart'        => 'Ext.chart.PieChart',

#Store xtypes
'arraystore'      => 'Ext.data.ArrayStore',
'directstore'     => 'Ext.data.DirectStore',
'groupingstore'   => 'Ext.data.GroupingStore',
'jsonstore'       => 'Ext.data.JsonStore',
'simplestore'     => 'Ext.data.SimpleStore', #      (deprecated; use arraystore)
'store'           => 'Ext.data.Store',
'xmlstore'        => 'Ext.data.XmlStore',
}

module Rwt
  class Component
    def render_create
      # Include components as items in extjs component
      @config.merge!(:items=>@components) if @components.length > 0

      # Render extjs code
      xtype= @config.delete(:xtype) || 'component'
      Rwt << "var #{self}=new #{XTYPE_CONSTRUCTOR[xtype]}(#{@config.render});"

      generate_events

    end

    def generate_events
      @event.each do |evt,block|
        Rwt << "#{self}.on('#{evt}',function("
        Rwt << @event_params[evt].join(',')
        Rwt << "){"
        block.call
        Rwt << "});"
      end
    end
  end
end
