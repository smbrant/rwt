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
      Rwt <<   "if(ret.id){Rwt.register[ret.id]=ret;}" # If have an id, regiter it
      Rwt <<   "ret(#{self});"
      Rwt << "};"
      Rwt << "var getJs=function(url,id){"
      Rwt <<   "if(Rwt.register[id]){"
      Rwt <<     "Rwt.register[id](#{self})"
      Rwt <<   "}else{"
      Rwt <<     "Ext.Ajax.request({"
      Rwt <<       "url: url,"
      Rwt <<       "success: exeJs,"
      Rwt <<       "failure: errJs"
      Rwt <<     "});"
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
