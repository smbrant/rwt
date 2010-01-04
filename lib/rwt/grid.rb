module Rwt
  def grid(*config,&block)
    Grid.new(*config,&block)
  end

  class Grid < Rwt::Component
  end
end
