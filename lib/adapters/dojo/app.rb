#
#  Dojo adapter for Rwt
#
module Rwt
  def call_view(url)
    JS.new("getJs.createCallback('#{url}')")
  end
  class App < Rwt::Component
    def init_cmp
      Rwt << "
         dojo.addOnLoad(function(){

           Rwt={};
           owner=Rwt;

           var errJs=function(response,options){
             alert('error');
           };

           var exeJs=function(response){
Rwt.response=response;
             eval(response+'(Rwt)');
             if(!response.valid){
//             var ret=eval(xhttp.responseText+'(Rwt)');
             }else{
               alert('error');
             }
           };

           var getJs=function(url){
             Ext.Ajax.request({
               url: url,
               success: exeJs,
               failure: errJs
             });
           };

           var getJs=function(url){
             dojo.xhrGet({
               url: url,
               handle: exeJs
             });
           };

Rwt.getJs=getJs;

           Rwt.message=function(title,message){
              alert(title+':'+message)
           };

//var accContainer = dijit.byId('ups' );
//var pane1 = new dijit.layout.AccordionPane({
//                    title: 'Madagascar Hissing Cockroach' ,
//                    href: '/teste.html'
//            });
//accContainer.addChild(pane1);

alert('inicio dojo');

         "
    end
    def render_create
      Rwt << '});' # completes dojo.addOnLoad(function(){
    end

  end

end