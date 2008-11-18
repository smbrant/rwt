#
# DbGridWindow: A window with a database grid
# 
# Parameters:
# 
#   :model -      active record model
#   :controller - action_controller
#   :title -      window title
#   :fields -     model fields to be shown in the grid
#                   ['field1','field2', ...] or
#                   ['field1',{:name=> 'field2', :fieldLabel=> 'Field2',  :xtype=> 'textfield', :width=>20},...] or
#                   [['field1','Title Field1'],[ ..]...] or
#                   [['field1','Title Field1',10],[ ..]...] where '10' is the width of field1
#                   
#   :pageSize -   number of records per page (defaults to 8)                
#   :filter -     defaults to true, enables/disables the filtering field
#   :readOnly -   defaults to false, if true inhibit modifications
#   :show_new_btn - true/false, force to show/hide new button
#   :show_edit_btn - true/false, force to show/hide edit button
#   :show_delete_btn - true/false, force to show/hide delete button
#   :id - an id to insert as a parameter in the json get (optional)
#   :json_params - a hash of parameters to send with the json request
#   :adv_search_view - url to adv_search view
#
# Revisions:
#   22/07/2008, smb, refactored, filtering option, your controller can treat a 'filter' parameter that is 
#               sent back each time the filtering field is modified.
#
require 'ext'

module Rwt
  class DbGridWindow
    @@x= 20  
    @@y= 20

    def self.new_x
      @@x+= 20; @@x= 40 if @@x > 100
      return @@x
    end

    def self.new_y
      @@y+= 20; @@y= 40 if @@y > 100
      return @@y
    end

    # Copied from Rwt::Component
    def prepare_owner # Create local callbacks for this component
      js( 
        "var errJs=function(response,options){",  # Error callback
        "};",
        "var exeJs= function(){};",               # Javascript execution callback (will be redefined by pass_owner)

        "var getJs=function(url){",               # getJs for this component (local var)
          "Ext.Ajax.request({",
            "url: url,",
            "success: exeJs,",
            "failure: errJs",
          "});",
        "}"
        ).render
    end

    def pass_owner(owner) # Redefines exeJs for this component (owner redefined)
      js( 
        "exeJs= function(xhttp){",             # Local javascript execution callback (created in prepare_owner)
          "var ret=eval(xhttp.responseText+'(#{owner})');", #   Execute received js
        "}"
        ).render
    end
    
    def owner  # just returns a javascritp var named 'owner' (it is passed to the js creation function)
      aowner=var()
      aowner.name='owner'
      return aowner
    end
    
    def call_view(url)
      js("getJs.createCallback('#{url}')")
    end

    # ... from component

    def json_params
      params=''
      if @json_params
        @json_params.each do |key,value|
          params << "&#{key.to_s}=#{value.to_s}"
        end
      end
      return params
    end


    def initialize(config)
      
      case config
        when Hash
          @x= config[:x] || DbGridWindow.new_x
          @y= config[:y] || DbGridWindow.new_y
          @model= config[:model] || nil
          @controller= config[:controller] || nil
          @fields= config[:fields] || @model.column_names
          @title= config[:title] || ''
          @authenticity_token= config[:authenticity_token] ||''
          @width= config[:width] || 500
          @height= config[:height] || 300
          @hideId= if config.key?(:hideId)
                      config[:hideId]
                    else
                      true
                    end
          @page_size= config[:pageSize] || 8
          @filter= if config.key?(:filter)
                      config[:filter]
                    else
                      true
                    end
          @read_only= if config.key?(:readOnly)
                      config[:readOnly]
                    else
                      false
                    end
          @print= if config.key?(:print)
                      config[:print]
                    else
                      false
                    end
          @id = config[:id] || nil
          @json_params= config[:json_params] || nil
          @adv_search_view= config[:adv_search_view] || nil

          @show_new_btn= if config.key?(:show_new_btn)
                      config[:show_new_btn]
                    else
                      false
                    end
          @show_edit_btn= if config.key?(:show_edit_btn)
                      config[:show_edit_btn]
                    else
                      false
                    end
          @show_delete_btn= if config.key?(:show_delete_btn)
                      config[:show_delete_btn]
                    else
                      false
                    end
          
      else
          raise "You should pass a hash as parameter"
      end
    end
    
    def render
      model_name= @model.name.underscore.upcase.swapcase
      controller_name= @controller.controller_name
      
      fields_a= [{:name=> 'id', :mapping=> 'id'}]
      fields_b= [{:id=> 'id', :header=>'#',:width=>10,:dataIndex=>'id', :hidden=>@hideId }]
      fields_json= []
      @fields.each do |f|
        case f
          when String
            f_name= f
            field={:fieldLabel=> f_name.capitalize}
            field[:name]=  "#{model_name}[#{f_name}]"
          when Hash
            f_name= f[:name]
            if !f[:fieldLabel]
              f[:fieldLabel]= f_name.capitalize
            end
            f[:name]="#{model_name}[#{f_name}]"
            field= f
          when Array
            f_name= f[0]
            field= {:name=> "#{model_name}[#{f_name}]"}
            if f.length > 1
              field[:fieldLabel]= f[1]
            else
              field[:fieldLabel]= f_name.capitalize
            end
            if f.length > 2
              field[:width]= f[2]
            end
        end
        fields_a << {:name=> "#{field[:name]}", :mapping=> "#{f_name}"}
        fields_b << {:header=>"#{field[:fieldLabel]}", :dataIndex=> "#{field[:name]}"}
        if field[:width]
          fields_b[-1].merge!({:width=>field[:width]})
        end
        fields_json << f_name
      end

        
      program(
        prepare_owner,
        ds=var(Ext::Data::Store.new({
              :proxy=>Ext::Data::HttpProxy.new({
                  :url=>"/#{controller_name}/index?format=json&id=#{@id}#{json_params}&fields=#{fields_json.join(',')}", # later &filter=value
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
        cm=var(Ext::Grid::ColumnModel.new(fields_b)),
        
#        "App.lastDs=#{ds}", # save ds temporaly in App.lastDs, the next open window will keep it in prived place
        
        grid=var(),

        new_btn={
                :text=>'Novo...',
                :tooltip=>'Criar um novo registro',
                :handler=>function(
                            "getJs('/#{controller_name}/new.js');"
                          ),
                :iconCls=>'add'
                },
        edit_btn={
                :text=>'Editar...',
                :tooltip=>'Editar o registro selecionado',
                :handler=> function(
                             "var selected = #{grid}.getSelectionModel().getSelected();",
                             'if(selected){',
#                                "App.lastDs=#{ds};",
                                "getJs('/#{controller_name}/edit/' + selected.data.id + '.js');",
                             '} else { ',
                               "App.message('Mensagem','Selecione um registro, por favor.');",
                             '}'
                           ),
                },
        delete_btn={
                  :text=>'Apagar...',
                  :tooltip=>'Apagar o registro selecionado',
                  :handler=> function(
                               "var selected = #{grid}.getSelectionModel().getSelected();",
                               'if(selected){',
                                 "if(confirm('Tem certeza?')){",
                                    'var conn = new Ext.data.Connection();',
                                    'conn.request({',
                                        "url:'/#{controller_name}/destroy/'+selected.data.id",
                                        ",params: {", # _method: 'DELETE',",
                                                  if @authenticity_token != ''
                                                    "authenticity_token: '#{@authenticity_token}'"
                                                  else
                                                    ''
                                                  end,
                                                "},",
                                        "success: function(response, options){ #{ds}.load(); },",
                                        "failure: function(response, options){ App.message('Falhou.'); }",
                                    "});",
                                 '}',
                               '} else { ',
                                 "App.message('Mensagem','Selecione um registro, por favor.');",
                               '}'
                             ),
                  :iconCls=>'remove'
                  },

        adv_search_btn={:xtype=>'button',
                    :width=>50,
                    :text=>'Pesquisa Avançada',
                    :handler=>call_view(@adv_search_view)
                  },

        explicit_buttons=[],
        if @show_new_btn
          explicit_buttons << new_btn
        end,
        if @show_edit_btn
          if explicit_buttons.length > 0
            explicit_buttons << '-'
          end
          explicit_buttons << edit_btn
        end,
        if @show_delete_btn
          if explicit_buttons.length > 0
            explicit_buttons << '-'
          end
          explicit_buttons << delete_btn
        end,
        if @adv_search_view
          if explicit_buttons.length > 0
            explicit_buttons << '-'
          end
          explicit_buttons << adv_search_btn
        end,
        grid.object=Ext::Grid::GridPanel.new({
            :ds=> ds,
            :cm=> cm,
            :sm=> Ext::Grid::RowSelectionModel.new({:singleSelect=>true}),
            :width=> @width-10,
            :height=> @height-50,
            :autoHeight=> true,
            :stripeRows=> true,
            :viewConfig=> {:forceFit=>true},
            :tbar=>if @read_only
              explicit_buttons
            else
              [
                new_btn,'-',edit_btn,'-',delete_btn,
                if @print
                  '-'
                else
                  {}
                end,
                if @print
                  {
                :text=>'Imprimir...',
                :tooltip=>'Imprimir o registro selecionado',
                :handler=> function(
                             "var selected = #{grid}.getSelectionModel().getSelected();",
                             'if(selected){',
                                "window.open('/#{controller_name}/print/' + selected.data.id );",
                             '} else { ',
                               "App.message('Mensagem','Selecione um registro, por favor.');",
                             '}'
                           ),
                   }
                else
                  {}
                end,
                if @adv_search_view
                  '-'
                else
                  {}
                end,
                if @adv_search_view
                  adv_search_btn
                else
                  {}
                end
            ]
            end
          }),

        if @read_only
          grid.on({
              :rowdblclick=>function(:grid,:row,:e,
#                  "App.lastDs=#{ds};",
                  "getJs('/#{controller_name}/show/'+grid.getStore().getAt(row).id+'.js')" # show
                )
            })
        else
          grid.on({
              :rowdblclick=>function(:grid,:row,:e,
#                  "App.lastDs=#{ds};",
                  "getJs('/#{controller_name}/edit/'+grid.getStore().getAt(row).id+'.js')" # edit
                )
            })
        end,
        
        "#{ds}.load({params: {start: 0, limit:#{@page_size}}})",
        
        thread=var('null'),

        search_field=var(),
        
        do_search=var(function(
            "if(#{thread}){clearInterval(#{thread})}",
            "#{ds}.proxy.conn.url='/#{controller_name}/index?format=json&fields=#{fields_json.join(',')}&filter='+#{search_field}.getValue();",
            "#{ds}.reload();"
          )),
        
        search_field.object=Ext::Form::TextField.new(
                    :width=>@width-10,
                    :enableKeyEvents=>true,
                    :listeners=>{
                         :keyup=>function(:f,:e,
                            "if(#{thread}){clearInterval(#{thread})}",
                            "#{thread}=setInterval(#{do_search},1000);"
                            )
                        }
                    ),
        control_panel= var({
            :xtype=>'panel',
            :border=>false,
#            :layout=>'column',
            :items=>[
               {:width=>@width-10,
                :border=>false,
                :items=>[search_field]
                }
             ]
          }),
        
        win=var(Ext::Window.new({
            :x=> @x,
            :y=> @y,
            :width=> @width,
            :height=> @height,
            :title=> @title,
            :items=>  if @filter
                        [control_panel,grid]
                      else
                        [grid]
                      end,
            :show=>false,
            :bbar=> Ext::PagingToolbar.new({
                      :pageSize=> @page_size,
                      :store=> ds,
                      :displayInfo=> true,
                      :displayMsg=> 'Registros {0} - {1} de {2}',
                      :emptyMsg=> "Nenhum registro encontrado"
              })
            })
          ),
        "#{win}.ds=#{ds}",
        pass_owner(win),
        win.show(),
        
        # focus on search field:
        "#{search_field}.focus.defer(150,#{search_field})"

      ).render

    end
  end
end