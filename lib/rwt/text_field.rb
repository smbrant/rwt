#
#  Rwt::TextField
#  ==============
#  
#  A text field
#
#  Config parameters/properties:
#  =============================
#  
#  name -  Name of field.
#     
#  Use
#  ===
#     
#  window(:title=>'Test Form') do |w|
#    w << form(:url=>'/test/create') do |f|
#      f << text_field(:name=>'name')
#      f << button(:text=>'submit') do |b|
#        b.on_click= f.submit
#      end
#    end
#    w.show
#  end
#     
module Rwt
  def text_field(*config,&block)
    TextField.new(*config,&block)
  end
  class TextField < Component
    attr_accessor :name

    def init_cmp
    end
    
    def render
      @name= @config.delete(:name) || @config[:id]
#      listeners=@config.delete(:listeners) || {}
#      listeners.merge!(:click=>@on_click) if @on_click
#      @config.merge!(:listeners=>listeners)
      @config.merge!(:name=>@name,:xtype=>'textfield')
      
      @config.render # Let Ext treat this
    end

  end 
end