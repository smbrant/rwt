module Rwt
  class Grid

    def render_create

      @components.each do |comp|
        if comp.class == Rwt::JsonStore # if given, consider as ds
          @config[:ds]=comp
        end
        if comp.class == Rwt::ColumnModel # if given, consider as cm
          @config[:cm]=comp
        end
      end
      @config[:sm]=js("new Ext.grid.RowSelectionModel({sigleSelect:true})") unless @config[:sm]
      @config[:viewConfig]={:forceFit=>true} unless @config[:viewConfig]

# Didn't work, components inserted as window children, see later...
#      if !@config[:cm]  # if do not have a cm, create one
#        c= Column.new('first')
#        cm= ColumnModel.new(:columns=>[c])
##
###        cm= Rwt::columnmodel do
###          @config[:ds].each do |data|
###            Rwt::column(data[:name])
###          end
###        end
#        @config[:cm]=cm
#        return nil
#      end

      Rwt << "var #{self}=new Ext.grid.GridPanel(#{@config.render});"
      generate_events
    end

  end
end
