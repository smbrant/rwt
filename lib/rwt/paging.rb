module Rwt
  def paging(*config,&block)
    PagingToolbar.new(*config,&block)
  end

  class PagingToolbar < Rwt::Component
  end
end
