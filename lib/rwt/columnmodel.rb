module Rwt
  def columnmodel(*config,&block)
    ColumnModel.new(*config,&block)
  end

  class ColumnModel < Rwt::Component
  end
end
