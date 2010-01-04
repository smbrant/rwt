module Rwt
  class Window
    def render_create
      @config.merge!(:items=>@components) if @components.length > 0
      @config.merge!(:title=>@title,:x=>@x,:y=>@y)

      @components.each do |component|
        if component.class == DbGrid # Include a paging toolbar if there is a dbgrid inside the window
          @config.merge!(:bbar=>js("new Ext.PagingToolbar({pageSize: #{component.config[:page_size]},store: ds})"))
        end
      end

      Rwt << "var #{self}=new Ext.Window(#{@config.render});"

      # Overrides exeJs and getJs passing this window as owner
      Rwt << "var exeJs=function(xhttp){"
      Rwt <<   "var ret=eval(xhttp.responseText);"
      Rwt <<   "if(ret.cache_id){Rwt.register[ret.cache_id]=ret;}" # If have an id, regiter view in the cache
      Rwt <<   "ret(#{self},ret.url);"
      Rwt << "};"
      Rwt << "var getJs=function(url,cache_id){"
      Rwt <<   "if(Rwt.register[cache_id]){"
      Rwt <<     "Rwt.register[cache_id](#{self},url)"
      Rwt <<   "}else{"
      Rwt <<     "if(cache_id){"
      Rwt <<       "Ext.Ajax.request({"
      Rwt <<         "url: url,"
      Rwt <<         "method: 'GET',"
      Rwt <<         "success: exeJs,"
      Rwt <<         "failure: errJs,"
      Rwt <<         "params: { register_as: cache_id }"
      Rwt <<       "});"
      Rwt <<     "}else{"
      Rwt <<       "Ext.Ajax.request({"
      Rwt <<         "url: url,"
      Rwt <<         "method: 'GET',"
      Rwt <<         "success: exeJs,"
      Rwt <<         "failure: errJs"
      Rwt <<       "});"
      Rwt <<     "}"
      Rwt <<   "}"
      Rwt << "};"

      generate_events

      show if @visible
    end

    def show
      Rwt << "#{self}.show();"
    end
    def close
      Rwt << "#{self}.close();"
    end

  end
end
