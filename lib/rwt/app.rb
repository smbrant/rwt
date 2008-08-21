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
  def rwt_app(config={},&block)
    App.new(config,&block)
  end
  def call_view(url)
    js("getJs.createCallback('#{url}')")
  end
  class App < Rwt::Component
    attr_accessor :tb # Main application toolbar
    def render
      code=js(
      # Ext basic configuration:
      "Ext.BLANK_IMAGE_URL='/ext/resources/images/default/s.gif';",
        
      # Waits for Ext to load and create the environment:
      "Ext.onReady(function(){",
        "Rwt={};",

        "var errJs=function(response,options){",  # Error callback
          # Perhaps log error in future
          "alert('error');",
        "};",

        "var exeJs= function(xhttp){",         # Execution callback
          "var ret=eval(xhttp.responseText+'(Rwt)');", # execute received js
          #not working in IE, pass Rwt allways, so, the js must be in the form (function(...){..})
#          "if(typeof(ret)=='function'){",      # if a function
#            "eval(ret(Rwt))",                    # call function passing rwt environment
#          "}",
        '};',

        "var getJs=function(url){",   # Get js from a url and execute it
          "Ext.Ajax.request({",
            "url: url,",
            "success: exeJs,",
            "failure: errJs",
          "});",
        "};",
        
        "Rwt.getJs=getJs;",
        'Rwt.debug= function(text){',     # Rwt.debug: send messages to debug window
          "if (!Rwt.debugWindow) {",
             "Rwt.debugWindow= new Ext.Window({title:'Rwt debug window',width:200,height:200,",
                 "x:document.body.getBoundingClientRect().right-200,y:0,",
                 "autoScroll:true ,closeAction:'hide',",
                 "tbar:[",
                        "{text:'Clear',handler:function(){while(Rwt.debugWindow.body.first()){Rwt.debugWindow.body.first().remove()}}}",
                      "]",
               "});",
             "Rwt.debugWindow.show();",
          "};",
          'var p= document.createElement("p");',
          'p.textContent= text;',
          'Rwt.debugWindow.body.appendChild(p);',
          "if (Rwt.debugWindow.hidden){Rwt.debugWindow.show()};",
        '};',

        "Rwt.message=function(title,message){",  # Show a message in a modal window
            "Ext.Msg.alert(title,message)",
        "};",
        "App=Rwt;"
      ).render
      @components.each do |cmp|
        code << cmp.render << '(Rwt);'   # Renders the component function passing the Rwt environment
      end
      code << '});'
    end

    # Can be deleted in future: (just for compatibility with SimpleApp)
    def self.jsFromUrl(url)
      js("getJs.createCallback('#{url}')")
    end

    def jsFromUrl(url)
      js("getJs.createCallback('#{url}')")
    end

  end

end