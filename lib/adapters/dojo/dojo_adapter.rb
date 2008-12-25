#
#  Dojo adapter for Rwt
#

puts "loading Dojo adapter ..."
#
# Helpers:
#
module ActionView
  module Helpers
    module JavaScriptHelper
      # pt_BR
      def rwt_javascript_libraries(language='en')
<<html_code
<style type="text/css">
    @import "/dojo/dojo/resources/dojo.css";
    @import "/dojo/dijit/themes/tundra/tundra.css" ;
</style>
<script type="text/javascript" src="/dojo/dojo/dojo.js" djConfig="parseOnLoad: true" ></script>
<script type="text/javascript">
   dojo.require("dojo.parser" );
</script>
html_code
#   dojo.require("dijit.layout.ContentPane" );
#   dojo.require("dijit.layout.TabContainer" );
#   dojo.require("dijit.layout.AccordionContainer" );
      end

      def rwt_body
        "<body class='tundra'>"+
          if !File.directory?(File.join(RAILS_ROOT,'public','ext'))
            "<p>You should copy or link the dojo library to the <b>/public/dojo</b> subdirectory."
          else
            ""
          end
      end
    end
  end
end

# Aditional adapters:
#require 'adapters/dojo/component'
require 'adapters/dojo/app'
#require 'adapters/dojo/toolbar'
#require 'adapters/dojo/window'
#require 'adapters/dojo/button'
#require 'adapters/dojo/form'
