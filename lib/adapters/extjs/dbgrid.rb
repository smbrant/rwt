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
              :text=>I18n.t('rwt.button.new.text'),
              :tooltip=>I18n.t('rwt.button.new.tooltip'),
              :handler=>function("#{self.owner}.ds=ds;",
                          "getJs('/#{controller_name}/new.rwt');"
                        ),
              :iconCls=>'add'
              }
      edit_btn={
              :text=>I18n.t('rwt.button.edit.text'),
              :tooltip=>I18n.t('rwt.button.edit.tooltip'),
              :handler=> function(
                           "var selected=#{self}.getSelectionModel().getSelected();",
                           'if(selected){',
                              "#{self.owner}.ds=ds;",
                              "getJs('/#{controller_name}/' + selected.data.id + '/edit.rwt');",
                           '} else { ',
                             "Rwt.message('",I18n.t('rwt.message'),"','",I18n.t('rwt.warning.select_record'),"');",
                           '}'
                         )
              }
      delete_txt= I18n.t('rwt.button.delete.text')
#      puts "delete_txt="+delete_txt
      delete_btn={
                :text=>delete_txt,
                :tooltip=>I18n.t('rwt.button.delete.tooltip'),
                :handler=> function(
                             "var selected = #{self}.getSelectionModel().getSelected();",
                             'if(selected){',
                               "if(confirm('",I18n.t('rwt.question.are_you_sure'),"')){",
                                  'var conn = new Ext.data.Connection();',
                                  'conn.request({',
                                      "url:'/#{controller_name}/'+selected.data.id+'.rwt'",
                                      ",params: { _method: 'DELETE',",
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
                               "Rwt.message('",I18n.t('rwt.message'),"','",I18n.t('rwt.warning.select_record'),"');",
                             '}'
                           ),
                :iconCls=>'remove'
                }

      adv_search_btn={:xtype=>'button',
                  :width=>50,
                  :text=>I18n.t('rwt.button.adv_search.text'),
                  :tooltip=>I18n.t('rwt.button.adv_search.tooltip'),
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
          :text=>I18n.t('rwt.button.print.text'),
          :tooltip=>I18n.t('rwt.button.print.tooltip'),
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
        get_dbl_click= "getJs('/#{controller_name}/'+#{self}.getStore().getAt(row).id+'.rwt')" # show
      else
        get_dbl_click= "getJs('/#{controller_name}/'+#{self}.getStore().getAt(row).id+'/edit.rwt')" # edit
      end

#                      root:'#{model_name}',

      Rwt << "
        var ds=new Ext.data.Store({
             proxy:new Ext.data.HttpProxy({
                     url:'/#{controller_name}?format=json&id=#{@id}#{json_params}&fields=#{fields_json}',
                     method: 'GET'
                   }),
             reader:new Ext.data.JsonReader({
                      root:'rows',
                      id: 'id',
                      totalProperty: 'count'
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
