module Rwt
  class DbGrid
    def render_create
      model_name= @model.name.underscore.downcase
      controller_name= @controller.controller_name

      fields_a= [{:name=> 'id', :mapping=> 'id'}]
      fields_b= [{:id=> 'id', :header=>'#',:width=>10,:dataIndex=>'id', :hidden=>@hideId }]
      fields_json= []
      @components.each do |f|
        f_name= f.config[:name]
        if !f.config[:fieldLabel]
          f.config[:fieldLabel]= f_name.capitalize
        end
        f.config[:name]="#{model_name}[#{f_name}]"

        fields_a << {:name=> "#{f.config[:name]}", :mapping=> "#{f_name}"}
        fields_b << {:header=>"#{f.config[:fieldLabel]}", :dataIndex=> "#{f.config[:name]}"}
        if f.config[:width]
          fields_b[-1].merge!({:width=>f.config[:width]})
        end
        fields_json << f_name
      end
      fields_json=fields_json.join(',')

      params= @authenticity_token!="" ? "params:{authenticity_token:'#{@authenticity_token}'}" : ""

      new_btn={
              :text=>t(:'rwt.button.new.text'),
              :tooltip=>t(:'rwt.button.new.tooltip'),
              :handler=>function("#{self.owner}.ds=ds;",
                          "getJs('/#{controller_name}/new?format=js');"
                        ),
              :iconCls=>'add'
              }
      edit_btn={
              :text=>t(:'rwt.button.edit.text'),
              :tooltip=>t(:'rwt.button.edit.tooltip'),
              :handler=> function(
                           "var selected=#{self}.getSelectionModel().getSelected();",
                           'if(selected){',
                              "#{self.owner}.ds=ds;",
                              "getJs('/#{controller_name}/edit/' + selected.data.id + '?format=js');",
                           '} else { ',
                             "Rwt.message('",t(:'rwt.message'),"','",t(:'rwt.warning.select_record'),"');",
                           '}'
                         )
              }
      delete_btn={
                :text=>t(:'rwt.button.delete.text'),
                :tooltip=>t(:'rwt.button.delete.tooltip'),
                :handler=> function(
                             "var selected = #{self}.getSelectionModel().getSelected();",
                             'if(selected){',
                               "if(confirm('",t(:'rwt.question.are_you_sure'),"')){",
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
                                      "success: function(response, options){ds.load();},",
                                      "failure: function(response, options){Rwt.message('Falhou.');}",
                                  "});",
                               '}',
                             '} else { ',
                               "Rwt.message('",t(:'rwt.message'),"','",t(:'rwt.warning.select_record'),"');",
                             '}'
                           ),
                :iconCls=>'remove'
                }

      adv_search_btn={:xtype=>'button',
                  :width=>50,
                  :text=>t(:'rwt.button.adv_search.text'),
                  :tooltip=>t(:'rwt.button.adv_search.tooltip'),
#                  :handler=>call_view(@adv_search_view)
                  :handler=>js("getJs.createCallback('#{@adv_search_view}')")
                }

      explicit_buttons=[]
      if @show_new_btn
        explicit_buttons << new_btn
      end
      if @show_edit_btn
        if explicit_buttons.length > 0
          explicit_buttons << '-'
        end
        explicit_buttons << edit_btn
      end
      if @show_delete_btn
        if explicit_buttons.length > 0
          explicit_buttons << '-'
        end
        explicit_buttons << delete_btn
      end
      if @adv_search_view
        if explicit_buttons.length > 0
          explicit_buttons << '-'
        end
        explicit_buttons << adv_search_btn
      end


      tbar=if @read_only
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
                       "var selected = #{self}.getSelectionModel().getSelected();",
                       'if(selected){',
                          "window.open('/#{controller_name}/print/' + selected.data.id );",
                       '} else { ',
                         "Rwt.message('Mensagem','Selecione um registro, por favor.');",
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

      if @read_only && !@show_edit_btn
        get_dbl_click= "getJs('/#{controller_name}/show/'+#{self}.getStore().getAt(row).id+'.js')" # show
      else
        get_dbl_click= "getJs('/#{controller_name}/edit/'+#{self}.getStore().getAt(row).id+'.js')" # edit
      end

      Rwt << "
        var ds=new Ext.data.Store({
             proxy:new Ext.data.HttpProxy({
                     url:'/#{controller_name}/index?format=json&id=#{@id}#{json_params}&fields=#{fields_json}',
                     method: 'GET'
                   }),
             reader:new Ext.data.JsonReader({
                      root:'#{model_name}',
                      id: 'id',
                      totalProperty: 'results'
                    },
                    #{fields_a.render}),
             remoteSort:true,
             sortInfo:{field:'id',direction:'ASC'}
           });
        cm=new Ext.grid.ColumnModel(#{fields_b.render});

        #{self}=new Ext.grid.GridPanel({
          ds:ds,
          cm:cm,
          sm:new Ext.grid.RowSelectionModel({sigleSelect:true}),
          width:#{@width-10},
          height:#{@height-50},
          autoHeight:true,
          stripeRows:true,
          viewConfig:{forceFit:true},
          tbar:#{tbar.render},
          listeners:{afterlayout:function(){alert('show do grid');#{self.owner}.ds=ds;}}
        });

        #{self}.on('rowdblclick',function(grid,row,e){#{self.owner}.ds=ds;#{get_dbl_click};});

        ds.load({params: {start: 0, limit:#{@page_size}}});
      "

    end
  end
end

#
#        thread=var('null'),
#
#        search_field=var(),
#
#        do_search=var(function(
#            "if(#{thread}){clearInterval(#{thread})}",
#            "#{ds}.proxy.conn.url='/#{controller_name}/index?format=json&fields=#{fields_json.join(',')}&filter='+#{search_field}.getValue();",
#            "#{ds}.reload();"
#          )),
#
#        search_field.object=Ext::Form::TextField.new(
#                    :width=>@width-10,
#                    :enableKeyEvents=>true,
#                    :listeners=>{
#                         :keyup=>function(:f,:e,
#                            "if(#{thread}){clearInterval(#{thread})}",
#                            "#{thread}=setInterval(#{do_search},1000);"
#                            )
#                        }
#                    ),
#        control_panel= var({
#            :xtype=>'panel',
#            :border=>false,
##            :layout=>'column',
#            :items=>[
#               {:width=>@width-10,
#                :border=>false,
#                :items=>[search_field]
#                }
#             ]
#          }),
#
#        win=var(Ext::Window.new({
#            :x=> @x,
#            :y=> @y,
#            :width=> @width,
#            :height=> @height,
#            :title=> @title,
#            :items=>  if @filter
#                        [control_panel,grid]
#                      else
#                        [grid]
#                      end,
#            :show=>false,
#            :bbar=> Ext::PagingToolbar.new({
#                      :pageSize=> @page_size,
#                      :store=> ds,
#                      :displayInfo=> true,
#                      :displayMsg=> 'Registros {0} - {1} de {2}',
#                      :emptyMsg=> "Nenhum registro encontrado"
#              })
#            })
#          ),
#        "#{win}.ds=#{ds}",
#        pass_owner(win),
#        win.show(),
#
#        # focus on search field:
#        "#{search_field}.focus.defer(150,#{search_field})"
#
#      ).render
