module Rwt
  class FieldSet
    def render_create
      @config.merge!(:items=>@components) if @components.length > 0
      Rwt << "var #{self}=new Ext.form.FieldSet(#{@config.render});"
      generate_events
    end
  end
end
