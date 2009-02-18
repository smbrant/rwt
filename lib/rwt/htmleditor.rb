module Rwt
  def htmleditor(*config,&block)
    HtmlEditor.new(*config,&block)
  end
  
  class HtmlEditor<Rwt::Component
  end 
end

