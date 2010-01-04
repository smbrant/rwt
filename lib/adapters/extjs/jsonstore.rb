module Rwt
  class JsonStore < Rwt::Component
    def render_create
      @config.merge!(:fields=>@components) if @components.length > 0
      restful= @config.delete(:restful) || true
      @config.merge!(:restful=>restful)
      autosave= @config.delete(:autoSave) || true
      @config.merge!(:autoSave=>autosave)
      autoload= @config.delete(:autoLoad) || true
      @config.merge!(:autoLoad=>autoload)
      @config.merge!(:writer=>js('new Ext.data.JsonWriter({encode: false})')) unless @config[:writer]
      Rwt << "var #{self}=new Ext.data.JsonStore(#{@config.render});"
      generate_events
    end

  end
end