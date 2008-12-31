#
#  ExtJs adapter for the Rwt::Form component
#
#  Revisions:
#    dec 15 2008, smb, initial.
#
module Rwt
  class Form

    def render_create
      if @components.length == 0
        @components << {:fieldLabel=> 'Test Field',:name=> 'test', :xtype=>'textfield'}
      end
      @config.merge!(:url=>@url,:items=>@components)
      if @authenticity_token
        @config.merge!(:baseParams=> {:authenticity_token=> @authenticity_token})
      end

      # Standard actioncomplete (valid if not re-defined through config):
      @config[:listeners]={} unless @config[:listeners]

#      try {
#                          }
#                        ev.time = t;
#                    } catch(ex) {
#                        this.lastError = ex;
#                        return t;
#                    }

      @config[:listeners][:actioncomplete]=function(:form,:action,
                              "if(action.type == 'submit'){",
                                 "if(!action.result.message){",
                                    "try{form.findParentByType('window').close()}catch(ex){}", # normally a window, should test?
                                    "if (owner.ds){owner.ds.load()};", # normally a index grid
                                 '}else{',
                                    "App.message('Mensagem',action.result.message);",
                                 "}",
                               "}"
            ) unless @config[:listeners][:actioncomplete]

      Rwt << "var #{self}=new Ext.FormPanel(#{@config.render});"

      generate_default_events

#      # autosize with owner?
#      if @owner && (@config[:width] == 'auto' || @config[:heigth] == 'auto')
#        code+=""
#      end
#
#
#  w.after_render=snippet(
#      win= var(w.jsObject), # win represents a javascript variable pointing to the window object
#      grid= var(gr.jsObject), # same for grid object
#      grid.setHeight(win.getInnerHeight()), # set the grid height to window inner height
#      on_resize=var(function(
#          grid.setHeight(win.getInnerHeight()),';',
#          grid.setWidth(win.getInnerWidth())
#        )),
#      "#{win}.on('resize',#{on_resize})"  # some hard coded javascript...
#    )
#


    end

    def submit
      Rwt << "#{self}.form.submit();"
    end

    def do_submit
      function("#{self}.form.submit()")
    end

    def set_values(values)
      case values
      when Array # Array of field/values especifications passed
        function("#{self}.form.setValues(",values,");")
      when ActiveRecord::Base # Model instance, try to populate fields in form with values from model
        model_name= values.class.name.underscore.upcase.swapcase  # model name
        form_values= []
        puts @components
        for field in @components do
          begin
            name= field_name(field)
            puts 'name='+name
            value= values.send(name)  # send to model object what is inside []
            if value
              value_s= value.to_s
              if value_s != ''
                form_values << {:id=>"#{model_name}[#{name}]",:value=>value_s}
              end
            end
          rescue
          end
        end
        return function("#{self}.form.setValues(",form_values,");")
      end
    end

    private
    def field_name(field_spec)
      pat=/\[.*\]/
      name= field_spec[:name] || field_spec[:hiddenName] || ''
      if p= name =~ pat
        name[p+1..-2]
      else
        name
      end
    end

  end
end
