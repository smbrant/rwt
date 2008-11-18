#
# DbEditWindow: A window with a form to edit/create a record
# 
# Parameters:
# 
#   :model -      active record model
#   :controller - action_controller
#   :title -      window title
#   :fields -     model fields to be shown in the form
#                   ['field1','field2', ...] or
#                   ['field1',{:name=> 'field2', :fieldLabel=> 'Field2',  :xtype=> 'textfield'},...]
#   :data -       data record
#   :id -         the id of record. If nil, create a new record
#   :labelWidth-  label width
#
require 'ext'

module Rwt
  class DbEditWindow
    def initialize(config)
      case config
        when Hash
          @model= config[:model] || nil
          @controller= config[:controller] || nil
          @fields= config[:fields] || @model.column_names
          @title= config[:title] || ''
          @authenticity_token= config[:authenticity_token] ||''
          @width= config[:width] || 500
          @height= config[:height] || 500
          @data= config[:data] || nil
          @title= config[:title] || ''
          @id= config[:id] || nil  # TODO: raise exception for all necessary parameters...
          @labelWidth= config[:labelWidth] || 120
        else
          raise "You should pass a hash as parameter"
      end
    end
    
    def render
      model_name= @model.name.underscore.upcase.swapcase
      controller_name= @controller.controller_name
      
      form_items= []
      form_values= []
      @fields.each do |f|
        case f
          when String  # Generates a field var of type Hash
            fName= f
            field={:fieldLabel=> fName.capitalize}
            field[:name]=  "#{model_name}[#{fName}]"
          when Hash  # Generates a field var of type Hash
            fName= f[:name]
            if !f[:fieldLabel]
              f[:fieldLabel]= fName.capitalize
            end
            f[:name]="#{model_name}[#{fName}]"
            field= f
          when Array  # Generates a field var of type Hash
            fName= f[0]
            field= {:name=> "#{model_name}[#{fName}]"}
            if f.length > 1
              field[:fieldLabel]= f[1]
            else
              field[:fieldLabel]= fName.capitalize
            end
          when Ext::Dict  # Generates a field var of type Dict
            fName= f.name
            if !f.fieldLabel
              f << {:fieldLabel=> fName.capitalize}
            end
            f << {:name=>"#{model_name}[#{fName}]"}
            field= f

#            field= {}                                                #
#            fName= f.name                                            #
#            field[:name]= "#{model_name}[#{fName}]"                  #
#            field[:fieldLabel] = f.fieldLabel || fName.capitalize    #
        end
        form_items << field
        if @id # Only generate values if id given (updating a record)
          case field  # According to case f above
            when Hash # String, Array ou Hash  --> Hash field
#              form_values << {:id=>field[:name],:value=>@data.send(fName).to_s_br||"''"}
#              form_values << {:id=>field[:name],:value=>@data.send(fName).to_s||"''"}
              form_values << {:id=>field[:name],:value=>@data.send(fName).to_s.gsub("\n","\\n")||"''"}
            when Ext::Dict # Dict --> Dict field
#              form_values << {:id=>field.name,:value=>@data.send(fName).to_s_br||"''"} # field.name only works because it's a Dict, see Dict class: method_missing
#              form_values << {:id=>field.name,:value=>@data.send(fName).to_s||"''"} # field.name only works because it's a Dict, see Dict class: method_missing
              form_values << {:id=>field.name,:value=>@data.send(fName).to_s.gsub("\n","\\n")||"''"} # field.name only works because it's a Dict, see Dict class: method_missing
          end
        end
      end

      program(
#        ds=var("App.lastDs"),  # ds aqui é uma variavel auxiliar, local

        win=var(Ext::Window.new({
                  :width=> @width,
                  :height=> @height,
                  :title=> @title || 'Edição de registro',
                  :modal=> true,
#                  :listeners=>{:close=>function("#{ds}.load()")},
                  :listeners=>{:close=>function("owner.ds.load()")},
                  :show=> false
                })),
            
        "Ext.form.Field.prototype.msgTarget = 'side'",
        panel=var(),
        panel.object=Ext::FormPanel.new({
                  :labelWidth=>   @labelWidth, # label settings here cascade unless overridden
                  :url=>          "/#{controller_name}/create",
                  :waitMsgTarget=> true,
                  :bodyStyle=>     'padding:5px 5px 0',
                  :width =>         @width-10,
                  :height =>        @height-50,
                  :defaults=>      {:width=> 250},
                  :defaultType=>   'textfield',
                  :baseParams=>    {:authenticity_token=> @authenticity_token},
                  :items=>   form_items,
                  :buttons=> [ {:text=> 'Salvar',  
                                :type=> 'submit',
                                :handler=> function(
                                              "#{panel}.getForm().submit(",
                                                      if @id
                                                        JS.new(
                                                        "{url:'/#{controller_name}/update/#{@id}?format=js'",
                                                        "}"
                                                        )
                                                      else
                                                        ''
                                                      end,
                                                    ');'
                                            )
                               },
                               {:text=> 'Fechar',  
                                :handler=> function("#{win}.close();")
                               }
                             ]
              }),

        panel.on({
            :actioncomplete=>function(:form,:action,
                              "if(action.type == 'submit'){",
                                 "if(!action.result.message){",
#                                    "#{win}.close();#{ds}.load();}",
#                                    "#{win}.close();owner.ds.load();",
                                    "#{win}.close();",
                                    "owner.ds.load();",
#                                    "Rwt.debug('fechando...');",
#                                    "owner.ds.load({params: {start: #{session[:atividade_pagination_state][:start]}, limit:#{session[:atividade_pagination_state][:limit]}}});",
#                                    "owner.ds.load({params: {start: 8, limit:8}});",
                                 '}else{',
                                    "App.message('Mensagem',action.result.message);",
                                 "}",
                               "}"
            )
          }
        ),
        
        win.add(panel),
        win.show(),
        
        # populate form values:
        form=var("#{panel}.form"),
        form.setValues(form_values),

        # go to first field in form
        first_field=var("#{form}.findField(0)"),
        "#{first_field}.focus.defer(150,#{first_field})"
        
      ).render
      
    end
  end
end