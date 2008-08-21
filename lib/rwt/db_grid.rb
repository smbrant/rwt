#
#  Rwt::DbGrid
#  ===========
#  
#  A database grid.
#  
#  Config parameters/properties:
#  =============================
#  
#  model -       active_record model
#  fields -      model fields to be shown in the grid, defaults to all fields in model
#                 ['field1','field2', ...] or
#                 ['field1',{:name=> 'field2', :fieldLabel=> 'Field2',  :xtype=> 'textfield'},...]
#  dataUrl -     url to be used for retrieving the data records (json format),
#                defaults to '/model_name/index.json'
#  filter -      defaults to true, allowing filtering of records displayed
#  
#  rowdblclick - double click event
#   
#  Any other parameter will be passed directly to Ext.
#  
#  Use
#  ===
#     
#  db_grid(:model=>Post) do |dbg|
#    dbg << ['title','text']
#    db.rowdblclick= message('record chosen')
#  end
#     

# this will go to the future db_grid_window:
#  createUrl -  url to be used for creation of records, defaults to '/controller_name/create'
#  updateUrl -  url to be used for record update, defaults to '/controller_name/update'
#  destroyUrl - url to be used for destroying records, defaults to '/controller_name/destroy'
#  showUrl -    url to be used for showing records, defaults to '/controller_name/show',
#                used when readOnly is true
#  readOnly -   edition is disabled, will use only showUrl


module Rwt
  def db_grid(config={},&block)
    DbGrid.new(config,&block)
  end
  
  class DbGrid < Rwt::Component
    attr_accessor :model, :controller
    
    attr_accessor :rowdblclick


    def init_cmp
      @model= @config.delete(:model) 
      raise MissingParameter unless @model
      @model_name= @model.name.underscore.downcase
      @dataUrl= @config.delete(:dataUrl) || "/#{@model_name}/index?format=json"
    end
    
    def render
      listeners=@config.delete(:listeners) || {}
      listeners.merge!(:rowdblclick=>@rowdblclick) if @rowdblclick
      @config.merge!(:listeners=>listeners)
      @config.merge!(:model=>@model)
      

      program(
        ds=var(Ext::Data::Store.new({
              :proxy=>Ext::Data::HttpProxy.new({
                  :url=>"/#{@dataUrl}&fields=#{fields_json.join(',')}", # later &filter=value
                  :method=> 'GET'
                }),
              :reader=> Ext::Data::JsonReader.new({
                          :root=> "#{model_name}",
                          :id=> 'id',
                          :totalProperty=> 'results'
                          },
                          fields_a),
              :remoteSort=> true,
              :sortInfo=> {:field=> 'id', :direction=> 'ASC'}
            })),
        grid=var(),
        grid.object=Ext::Grid::GridPanel.new({
#            :ds=> ds,
#            :cm=> cm,
            :sm=> Ext::Grid::RowSelectionModel.new({:singleSelect=>true}),
            :autoHeight=> true,
            :stripeRows=> true,
            :viewConfig=> {:forceFit=>true}
        }),
        ""
      ).render
    end

  end 
end