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
        if File.directory?(File.join(RAILS_ROOT,'public','ext','src'))
          source_dir= 'src' # ext-3...
        else
          source_dir= 'source'  # ext-2...
        end

# Rehfeld:
#  <link href="/stylesheets/ext_scaffold.css" media="screen" rel="stylesheet" type="text/css" />
##  <link href="/stylesheets/../ext/resources/css/ext-all.css" media="screen" rel="stylesheet" type="text/css" />
#  <script src="/javascripts/prototype.js" type="text/javascript"></script>
#  <script src="/javascripts/effects.js" type="text/javascript"></script>
#
#  <script src="/javascripts/dragdrop.js" type="text/javascript"></script>
#  <script src="/javascripts/controls.js" type="text/javascript"></script>
#  <script src="/javascripts/application.js" type="text/javascript"></script>
#  <script src="/javascripts/../ext/adapter/prototype/ext-prototype-adapter.js" type="text/javascript"></script>
#  <script src="/javascripts/../ext/ext-all.js" type="text/javascript"></script>
#  <script src="/javascripts/../ext/source/locale/ext-lang-en.js" type="text/javascript"></script>
#  <script src="/javascripts/ext_datetime.js" type="text/javascript"></script>

<<html_code
<link rel="stylesheet" type="text/css" href="/ext/resources/css/ext-all.css" />
<script type="text/javascript" src="/ext/adapter/ext/ext-base.js"></script>
<script type="text/javascript" src="/ext/#{source_dir}/locale/ext-lang-#{language}.js"></script>
<script type="text/javascript" src="/ext/ext-all.js"></script>
html_code
#<script type="text/javascript" src="/javascripts/html_editor_fix.js"></script>
      end

      def rwt_body
        "<body scroll='no'>"+
          if !File.directory?(File.join(RAILS_ROOT,'public','ext'))
            I18n.t('rwt.error.loading.extjs')
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
require 'adapters/extjs/container'
require 'adapters/extjs/data'
require 'adapters/extjs/jsonstore'
require 'adapters/extjs/grid'
require 'adapters/extjs/columnmodel'
require 'adapters/extjs/column'