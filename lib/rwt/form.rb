module Rwt
  #
  #  Rwt::Form
  #  =========
  #
  #  Config parameters
  #  =================
  #  
  #  url - submit url
  #     
  #  Use
  #  ===
  #     
  #  window(:title=>'Test Form') do |w|
  #    w << form(:url=>'/test/create') do |f|
  #      f << button(:text=>'submit') do |b|
  #        b.on_click= f.submit
  #      end
  #    end
  #    w.show
  #  end
  #     
  def form(*config,&block)
    Form.new(*config,&block)
  end
  class Form < Rwt::Component
    attr_accessor :url
    attr_accessor :authenticity_token

    def buttons
      @config[:buttons] || @config[:buttons]=[]
    end
    
    def buttons=(value)
      @config[:buttons]= value
    end
    
    def init_default_par(non_hash_params)
       @config[:url]=non_hash_params[0] if non_hash_params[0].class == String
       @config[:title]=non_hash_params[1] if non_hash_params[1].class == String
    end
    
    def init_cmp
      @url= @config.delete(:url) || ''
      @authenticity_token= @config.delete(:authenticity_token)
      @config[:width]= 'auto' unless @config[:width]
      @config[:height]= 'auto' unless @config[:height]
    end
    
    def submit
#      function("Ext.getCmp('#{@config[:id]}').form.submit()")
      function("#{jsObject}.form.submit()")
    end
    
    def set_values(values)
      case values
      when Array # Array of field/values especifications passed
        function("#{jsObject}.form.setValues(",values,");")
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
        return function("#{jsObject}.form.setValues(",form_values,");")
      end
    end
    
    def render
#      listeners=@config.delete(:listeners) || {}
#      listeners.merge!(:click=>@click) if @click
#      @config.merge!(:listeners=>listeners)
      if @components.length == 0
        @components << {:fieldLabel=> 'Test Field',:name=> 'test', :xtype=>'textfield'}
      end
      @config.merge!(:url=>@url,:xtype=>'form',:items=>@components)
      if @authenticity_token
        @config.merge!(:baseParams=> {:authenticity_token=> @authenticity_token})
      end
      
      # Standard actioncomplete (valid if not re-defined through config):
      @config[:listeners]={} unless @config[:listeners]
      @config[:listeners][:actioncomplete]=function(:form,:action,
                              "if(action.type == 'submit'){",
                                 "if(!action.result.message){",
                                    "#{@owner.jsObject}.close();", # normally a window, should test?
                                    "if (owner.ds){owner.ds.load()};", # normally a index grid
                                 '}else{',
                                    "App.message('Mensagem',action.result.message);",
                                 "}",
                               "}"
            ) unless @config[:listeners][:actioncomplete]
      
      
      
      @config.render # Let Ext treat this
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