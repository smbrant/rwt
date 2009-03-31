module Rwt
  #  
  #  Rwt::App
  #  ========
  #  
  #  The basic ruby and javascript environments of a Rwt application.
  #  
  #  Use
  #  ===
  #  
  #  rwt_app do |app|
  #    app << toolbar(:place=>'header') do |tb|
  #      tb << {:text=>'test',
  #             :menu=>{:items=>[
  #                        {:text=>'A mensage',:handler=>message('test1')},
  #                        {:text=>'An other window',:handler=>call_view('/test/app1_test2')},
  #                    ]}
  #             }
  #    end
  #  end
  #  
  def rwt_app(*config,&block)
    App.new(*config,&block)
  end

  #
  #  call_view
  #  =========
  #
  #  
  #
  def call_view(url,id=nil)
    t(:'rwt.adapter.should_generate_code', :adapter=>Rwt.adapter )
  end

  class App < Rwt::Component
    attr_accessor :tb # Main application toolbar
  end

end

