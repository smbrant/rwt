module Rwt
  class EditForm
    def render_create
      model_name= @model.name.underscore.downcase
      controller_name= @controller.controller_name

      form_values=[]
      @components.each do |f|
        f_name= field_name(f.config)
        if !f.config[:fieldLabel]
          f.config[:fieldLabel]= f_name.capitalize
        end
        if @id # Only generate values if id given (updating a record)
          form_values << {:id=>f.config[:name],:value=>@model_data.send(f_name).to_s.gsub("\n","\\n").gsub("\r","")||"''"}
        end
      end

      puts @id
      if @id
        url="/#{controller_name}/#{@id}.rwt" # with PUT
        meth='PUT'
      else
        url="/#{controller_name}.rwt" # with POST
        meth='POST'
      end

      Rwt << "
        Ext.form.Field.prototype.msgTarget = 'side';
        #{self}=new Ext.FormPanel({
          labelWidth: #{@label_width},
          url:'#{url}',
          waitMsgTarget:true,
          bodyStyle:'padding:5px 5px 0',
          width:#{@width},
          height:#{@height},
          defaults:{width:250},
          defaultType:'textfield',
          baseParams:{authenticity_token:'#{@authenticity_token}'},
          items:#{@components.render},
          buttons:[{text:'Salvar',
                    type:'submit',
                    handler:function(){#{self}.form.submit({method:'#{meth}'})},
                   },
                   {text:'Fechar',
                    handler:function(){#{self.owner}.close()}
                   }
                  ]
        });
        #{self}.on({
          actioncomplete:function(form,action){
                           if(action.type=='submit'){
                             #{self.owner}.close();
                             owner.ds.load();
                           }else{
                             Rwt.message('Mensagem',action.result.message);
                           }
                         }
        });

        #{self}.form.setValues(#{form_values.render});

        #{self}.on('afterlayout',function(){
                                   #{self}.form.setValues(#{form_values.render});
                                   var first_field=#{self}.form.findField(0);
                                   first_field.focus.defer(150,first_field);
                                 }
                  );

      "
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
