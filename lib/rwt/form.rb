module Rwt
  #
  #  Rwt::Form
  #  =========
  #
  #  Config parameters
  #  =================
  #  
  #  url - submit url
  #  authenticity_token - rails authenticity_token (if in use)
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
    Form.new(self,*config,&block)
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
      @config[:frame]= true unless @config.has_key?(:frame)
      @config[:defaultType]= 'textfield' unless @config[:defaultType]
      @config[:bodyStyle]= 'padding:5px 5px 0' unless @config[:bodyStyle]

      #      :bodyStyle=>'padding:5px 5px 0',
    end
    
  end 
end
