module Rwt

  #
  # call_view should be use in menu_item
  #
  def call_view(url,id=nil)
    if id
      JS.new("getJs.createCallback('#{url}','#{id}')")
    else
      JS.new("getJs.createCallback('#{url}')")
    end
  end

  #
  # show_view should be used in the following pattern:
  #
  # button('test') do |b|
  #   b.on('click') do
  #     show_view('/x/y/z')
  #   end
  # end
  #
  #TODO: call_view should be changed to this pattern (after fixing other parts)
  #
  def show_view(url,id=nil)
    if id
      Rwt << "getJs('#{url}','#{id}');"
    else
      Rwt << "getJs('#{url}');"
    end
  end

  def show_html(url)
    Rwt << "window.location='#{url}';"
  end

  class App < Rwt::Component
    def init_cmp
      Rwt << "
         Ext.BLANK_IMAGE_URL='/ext/resources/images/default/s.gif';
         Ext.onReady(function(){
           Ext.QuickTips.init();

           Rwt={};
           Rwt.register={};
           owner=Rwt;

           var errJs=function(response,options){
             alert('error');
           };

           var exeJs=function(xhttp){
             var ret=eval(xhttp.responseText);
             if(ret.cache_id){Rwt.register[ret.cache_id]=ret;}
             ret(Rwt,ret.url);
           };

           var getJs=function(url,cache_id){
             if(Rwt.register[cache_id]){
               Rwt.register[cache_id](Rwt,url)
             }else{
               if(cache_id){
                 Ext.Ajax.request({
                   url: url,
                   method: 'GET',
                   success: exeJs,
                   failure: errJs,
                   params: { register_as: cache_id }
                 });
               }else{
                 Ext.Ajax.request({
                   url: url,
                   method: 'GET',
                   success: exeJs,
                   failure: errJs
                 });
               }
             }
           };

           Rwt.getJs= getJs;

           Rwt.debug= function(text){
             if(!Rwt.debugWindow){
                 Rwt.debugWindow=new Ext.Window({title:'Rwt debug window',width:200,height:200,
                   x:document.body.getBoundingClientRect().right-200,y:0,
                   autoScroll:true ,closeAction:'hide',
                   tbar:[
                      {text:'Clear',handler:function(){while(Rwt.debugWindow.body.first()){Rwt.debugWindow.body.first().remove()}}}
                        ]
                  });
                 Rwt.debugWindow.show();
               };
             var p=document.createElement('p');
             p.textContent= text;
             Rwt.debugWindow.body.appendChild(p);
             if(Rwt.debugWindow.hidden){Rwt.debugWindow.show()};
           };

           Rwt.message=function(title,message){
              Ext.Msg.alert(title,message)
           };
         "
    end

    def render_create
      Rwt << '});' # completes Ext.onReady(function(){
    end

  end

end

