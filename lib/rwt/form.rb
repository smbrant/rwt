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
  def form(config={},&block)
    Form.new(config,&block)
  end
  class Form<Rwt::Component
    attr_accessor :url
    attr_accessor :authenticityToken

    def init_cmp
      @url= @config.delete(:url) || ''
      @authenticityToken= @config.delete(:authenticityToken)
    end
    
    def submit
      function("Ext.getCmp('#{@config[:id]}').form.submit()")
    end
    
    def render
#      listeners=@config.delete(:listeners) || {}
#      listeners.merge!(:click=>@click) if @click
#      @config.merge!(:listeners=>listeners)
      @config.merge!(:url=>@url,:xtype=>'form',:items=>@components)
      if @authenticityToken
        @config.merge!(:baseParams=> {:authenticity_token=> @authenticityToken})
      end
      
      @config.render # Let Ext treat this
    end

  end 
end