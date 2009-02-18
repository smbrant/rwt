#
#  ExtJs adapter for Rwt
#

# puts "loading ExtJs adapter ..."

#
# Helpers:
#
module ActionView
  module Helpers
    module JavaScriptHelper
      # pt_BR
      def rwt_javascript_libraries(language='en')
<<html_code
<link rel="stylesheet" type="text/css" href="/ext/resources/css/ext-all.css" />
<script type="text/javascript" src="/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/ext/ext-all.js"></script>
<script type="text/javascript" src="/ext/source/locale/ext-lang-#{language}.js"></script>
html_code
#<script type="text/javascript" src="/javascripts/html_editor_fix.js"></script>
      end

      def rwt_body
        "<body scroll='no'>"+
          if !File.directory?(File.join(RAILS_ROOT,'public','ext'))
            "<p><b>Error while trying to load the ExtJs library</b></p>"+
            "<p>You should copy or link the extjs library to the <b>/public/ext</b> subdirectory.</p>"+
            "<p>If you prefer you could use <b>rake rwt:install_extjs</b> instead.</p>"
          else
            ""
          end
      end
    end
  end
end

# Aditional adapters:
require 'adapters/extjs/component'
require 'adapters/extjs/app'
require 'adapters/extjs/toolbar'
require 'adapters/extjs/window'
require 'adapters/extjs/button'
require 'adapters/extjs/form'
require 'adapters/extjs/field'
require 'adapters/extjs/tabpanel'
require 'adapters/extjs/fieldset'
require 'adapters/extjs/dbgrid'
require 'adapters/extjs/editform'
require 'adapters/extjs/panel'
require 'adapters/extjs/htmleditor'