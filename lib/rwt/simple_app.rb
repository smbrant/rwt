#
#  Rails Web Toolkit - (c) accesstecnologia.com.br
#  
#  SimpleApp
#  
#  An application based in a simple toolbar.
#  See an example of use in the test file test_simple_app.rb
# 
#  Revisions:
#   01/05/08, smb, initial version
#   31/07/08, smb, method for class instantiation and new executeJs callback
#
module Rwt
  def simple_app(config={},&block)
    SimpleApp.new(config,&block)
  end
#  def show_view(url)
#    SimpleApp.jsFromUrl(url)
#  end
  class SimpleApp < Ext::List
    
    def prologue
      JS.new(
        # Utilities:
#        'function loadExternalfile(filename, filetype){',
#          'if (filetype=="js"){',
#            'var fileref=document.createElement("script");',
#            'fileref.setAttribute("type","text/javascript");',
#            'fileref.setAttribute("src", filename);',
#            '}',
#          'else if (filetype=="css"){',
#            'var fileref=document.createElement("link");',
#            'fileref.setAttribute("rel", "stylesheet");',
#            'fileref.setAttribute("type", "text/css");',
#            'fileref.setAttribute("href", filename);',
#          '};',
#          'if (typeof fileref!="undefined")',
#            'document.getElementsByTagName("head")[0].appendChild(fileref);',
#        '};',

        
        # Load the ext lib:
#        'loadExternalfile("http://localhost:3000/ext/resources/css/ext-all.css", "css");',
#        'loadExternalfile("http://localhost:3000/ext/adapter/ext/ext-base.js", "js");',
#        'loadExternalfile("http://localhost:3000/ext/ext-all.js", "js");',
#        'loadExternalfile("http://localhost:3000/ext/source/locale/ext-lang-pt_BR.js", "js");',
#        'alert("carregou");',

        # The simple application:
        'Ext.BLANK_IMAGE_URL = ',"'/ext/resources/images/default/s.gif';",
        'Ext.onReady(function(){',
          'App={};',
          'function error(response,options){',
#            "alert('error getting js');",
#            "alert(response.responseText);",
          '};',

          "function executeJs(xhttp){",        # Execution callback
            "var ret=eval(xhttp.responseText);", # execute received js
            "if(typeof(ret)=='function'){",      # if a function
              "eval(ret(App))",                    # call function passing app environment
            "}",
          '};',
        
          'function getJs(url){',
            'Ext.Ajax.request({',
              'url: url,',
              'success: executeJs,',
              'failure: error',
#              "params: { format: 'js' }",
            '});',
          '};',

          'App.error=function(response,options){',
#            "alert('error getting js');",
#            "alert(response.responseText);",
          '};',
          'App.executeJs= function(xhttp){',
            'eval(xhttp.responseText);',
#            'alert(xhttp.responseText);',
          '};',
          'App.getJs=function(url){',
            'Ext.Ajax.request({',
              'url: url,',
              'success: executeJs,',
              'failure: error',
#              "params: { format: 'js' }",
            '});',
          '};',

          # debug: apresenta mensagem na janela de debug
          'App.debug= function(text){',
            "if (!App.debugWindow) {",
               "App.debugWindow= new Ext.Window({title:'Rwt debug window',width:200,height:200,",
                   "x:document.body.getBoundingClientRect().right-200,y:0,",
                   "autoScroll:true ,closeAction:'hide',",
                   "tbar:[",
                          "{text:'Clear',handler:function(){while(App.debugWindow.body.first()){App.debugWindow.body.first().remove()}}}",
                        "]",
                 "});",
               "App.debugWindow.show();",
            "};",
            'var p= document.createElement("p");',
            'p.textContent= text;',
            'App.debugWindow.body.appendChild(p);',
            "if (App.debugWindow.hidden){App.debugWindow.show()};",
          '};',
          
          # filtraTexto: retira caracteres especiais do texto
          "App.filtraTexto= function(texto){",
              "var s = '';",
              "var vr = texto;",
              "var tam = vr.length;",
              "for (i = 0; i < tam ; i++) {",
                      "if (vr.substring(i,i + 1) != '/' && vr.substring(i,i + 1) != '-' && vr.substring(i,i + 1) != '.'  && vr.substring(i,i + 1) != ',' ){",
                              "s = s + vr.substring(i,i + 1);}",
              "}",
              "return s",
          "};",

          # formataCpfCnpj: formata o campo como cpf ou cnpj
          "App.formataCpfCnpj= function(texto){",
            "var s = texto;",
            "var vr = App.filtraTexto(texto);",
            "var tam = vr.length ;",
            "if ( tam <= 2 ){",
                    "s=vr;}",
            "if ( tam > 2 && tam <= 5 ){",
                    "s= vr.substr( 0, tam - 2 ) + '-' + vr.substr( tam - 2, tam );}",
            "if ( tam >= 6 && tam <= 8 ){",
                    "s= vr.substr( 0, tam - 5 ) + '.' + vr.substr(tam - 5, 3 ) + '-' + vr.substr( tam - 2, tam );}",
            "if ( tam >= 9 && tam <= 11 ){",
                    "s= vr.substr( 0, tam - 8 ) + '.' + vr.substr( tam - 8, 3 ) + '.' + vr.substr(tam - 5, 3 ) + '-' + vr.substr( tam - 2, tam );}",
            "if ( tam == 12 ){",
                    "s= vr.substr( 0, 3 ) + '.' + vr.substr( 3, 3 ) + '/' + vr.substr(6, 4 ) + '-' + vr.substr( 10, 2 );}",
            "if ( tam >= 13 && tam <= 14 ){",
                    "s= vr.substr( 0, tam - 12 ) + '.' + vr.substr( tam - 12, 3 ) + '.' + vr.substr(tam - 9, 3 ) + '/' + vr.substr( tam - 6 , 4 )+ '-' + vr.substr( tam - 2, tam );}",
            "return s;",
          "};",
          
          # message: show a message in a new window
          "App.message=",function(:title,:message,
              "Ext.Msg.alert(title,message);"
              
          #versao antiga:
#            program(
#              bt= var({:text=>'Fechar',:handler=>function("this.findParentByType('window').close()")}),
#              win= var(Ext::Window.new(
#                :show=>false,
#                :modal=>true,
#                :title=>js('title'),
#                :html=>js('message'),
#                :buttons=>[bt]
#              )),
#              win.show()
#            )
          ),";",


        # Rwt available here during transition of App to Rwt
        "Rwt={};",

        "var errJs=function(response,options){",  # Error callback
          # Perhaps log error in future
        "};",

        "var exeJs= function(xhttp){",         # Execution callback
          "var ret=eval(xhttp.responseText);", # execute received js
          "if(typeof(ret)=='function'){",      # if a function
            "eval(ret(Rwt))",                    # call function passing rwt environment
          "}",
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
        
        
        
          "App.windows= [];",
          "App.register= function(id){App.windows.add(id)};",
          "App.getWindow= function(id){return undefined};",
          "App.tb = new Ext.Toolbar({id:'desktop_tb',items: ["
      ).render
    end

    def epilogue
      JS.new(
          ']});',
          "if (!Ext.get('simple-app')) {",
            'var div= document.createElement("div");',
            'div.setAttribute("id","simple-app");',
            'document.getElementsByTagName("body")[0].appendChild(div);',
          '};',
          "App.tb.render('simple-app');",
          "Rwt.tb=App.tb;",  # for compatibility, temporary
        '});'
      ).render
    end

    def self.jsFromUrl(url)
      JS.new("getJs.createCallback('#{url}')")
    end

    def jsFromUrl(url)
      JS.new("getJs.createCallback('#{url}')")
    end
    
#    def self.showOrCreate(varName,url)
#      JS.new("showOrCreate.createCallback(#{varName},'#{url}')")
#    end
#
#    def showOrCreate(varName,url)
#      JS.new("showOrCreate.createCallback(#{varName},'#{url}')")
#    end
    
  end

end