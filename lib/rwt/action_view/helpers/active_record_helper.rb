module ActionView
  module Helpers
    module ActiveRecordHelper
      #
      #  check
      #  =====
      #
      #  Returns the eval of expression passed as a string or '' if the expression
      #  is invalid
      #
      def check(expression='')
        begin
          ret = eval(expression)
          ret == nil ? '' : ret
        rescue
          return ''
        end
      end

      def check_html(expression='')
        begin
          ret = eval(expression)
          ret == nil ? '&nbsp;' : ret
        rescue
          return '&nbsp;'
        end
      end
    end
  end
end


