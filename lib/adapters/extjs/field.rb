module Rwt
  class Field
    def render_create
      Rwt << "var #{@config[:id]}=#{@config.render};"
    end
  end
end
