#
# DialogWindow: A window with a form: can be used for entering search parameters, etc.
# 
# Parameters:
# 
#   :controller - action_controller to be called when OK button is clicked
#   :action -     action to be called when OK button is clicked
#   :title -      window title
#   :fields -     model fields to be shown in the form
#                  ['field1','field2', ...] or
#                  ['field1',{:name=> 'field2', :fieldLabel=> 'Field2', :value=>'Initial Value' :xtype=> 'textfield'},...]
#   :width - width of the window
#   :height - height of the window
#   :labelWidth - label width
#   :js - indicates if url formed by :controller/:action should be treated as a js code
#
require 'ext'

module Rwt
  class DialogWindow
    def initialize(config)
      case config
        when Hash
          @controller= config[:controller] || nil
          @action= config[:action] || nil
          @fields= config[:fields] || nil
          @authenticity_token= config[:authenticity_token] ||''
          @width= config[:width] || 500
          @height= config[:height] || 500
          @title= config[:title] || 'Caixa de Diálogo'
          @labelWidth= config[:labelWidth] || 120
          @js = config[:js] || false
        else
          raise "You should pass a hash as parameter"
      end
    end
    
    def render
      controller_name= @controller.controller_name
      
      form_items= []
      form_values= []
      @fields.each do |f|
        case f
          when String  # Generates a field var of type Hash
            field={:fieldLabel=> f.capitalize}
            field[:name]= f
          when Hash  # Generates a field var of type Hash
            if !f[:fieldLabel]
               f[:fieldLabel]= f[:name].capitalize
            end
            field= f
          when Array  # Generates a field var of type Hash
            field= {:name=> f[0]}
            if f.length > 1
              field[:fieldLabel]= f[1]
            else
              field[:fieldLabel]= f[0].capitalize
            end
          when Ext::Dict  # Generates a field var of type Dict
            if !f.fieldLabel
              f << {:fieldLabel=> f.name.capitalize}
            end
            f << {:name=>f.name}
            field= f

        end
        form_items << field
        case field  # According to case f above
          when Hash # String, Array ou Hash  --> Hash field
            form_values << {:id=>field[:name],:value=>field[:value].to_s||"''"}
          when Ext::Dict # Dict --> Dict field
            form_values << {:id=>field.name,:value=>field.value.to_s||"''"} # field.name only works because it's a Dict, see Dict class: method_missing
        end
      end

      program(
#        ds=var("App.lastDs"),  # ds aqui é uma variavel auxiliar, local

        win=var(Ext::Window.new({
                  :width=> @width,
                  :height=> @height,
                  :title=> @title,
                  :modal=> true,
#                  :listeners=>{:close=>function("#{ds}.load()")},
#                  :listeners=>{:close=>function("owner.ds.load()")},
                  :show=> false
                })),

        "Ext.form.Field.prototype.msgTarget = 'side'",
        panel=var(),
        panel.object=Ext::FormPanel.new({
                  :labelWidth=>   @labelWidth, # label settings here cascade unless overridden
                  :url=>          "/#{controller_name}/#{@action}",
                  :waitMsgTarget=> true,
                  :bodyStyle=>     'padding:5px 5px 0',
                  :width =>         @width-10,
                  :height =>        @height-50,
                  :defaults=>      {:width=> 250},
                  :defaultType=>   'textfield',
                  :baseParams=>    {:authenticity_token=> @authenticity_token},
                  :items=>   form_items,
                  :buttons=> [ {:text=> 'OK',  
                                :type=> 'submit',
                                :handler=> function(if @js
                                                       call_view("/#{controller_name}/#{@action}")
                                                    else
                                                       "#{panel}.getForm().submit();"
                                                    end,
                                                    "#{win}.close();")
                               },
                               {:text=> 'Cancelar',  
                                :handler=> function("#{win}.close();")
                               }
                             ]
              }),

#        panel.on({
#            :actioncomplete=>function(:form,:action,
#                              "if(action.type == 'submit'){",
#                                 "if(!action.result.message){",
##                                    "#{win}.close();owner.ds.load();}",
#                                    "#{win}.close();}",
#                                 'else{',
#                                    "App.message('Mensagem',action.result.message);",
#                                 "}",
#                               "}"
#            )
#          }
#        ),
        
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