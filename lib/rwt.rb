#
#  Rails Web Toolkit
#  =================
#  
#  Rwt is a visual web framework built on top of javascript libraries.
# 
#  The Rwt module should be included in the application controller or 
#  installed using the rwt plugin.
#
#  Authors: smbrant@gmail.com,
#
#  Documentation: http://rwt.accesstecnologia.com.br
#
#  Revisions:
#
#  v. 1.0, smb, Jun 02 2008
#    Initial version, lots of changes during 2008.
#
#  v. 2.0, smb, Dec 06 2008
#    First re-write, changed the way render is done in order to ease coding programs
#    and not only creating objects from config parameters.
#    More than one javascript library can be plugged-in. Initially ExtJs and Dojo.
#
module Rwt
  # Configuration
  @@config={:adapter=>'extjs',  # Javascript adapter
            :minify=>true}      # Minify generated code?

  def self.adapter
    @@config[:adapter]
  end

  #
  #  Set configuration
  #
  def self.set(config={})
    @@config.merge!(config)
  end

  #
  #  Rwt components generate javascript code in a buffer that later is sent
  #  to execution in the client (browser).
  #
  @@code_buffer= "" # The code buffer. Components should insert javascript here

  def self.clear  # Normally the code is cleared after each rwt_render
    @@code_buffer= ""
  end

  def self.<<(code_string) # Inserts code in buffer
    if @@config[:minify] == true then # warning: do not support javascript comments
      lines= code_string.split("\n")
      lines.each do |line|
        @@code_buffer << line.gsub(/^\s+/,"").gsub(/\s+$/,"") # trimmed left and right
      end
    else
      @@code_buffer << code_string
    end
  end

  def self.code # Gets code in buffer
    @@code_buffer
  end

  #
  #  load_adapter
  #  ============
  #
  #  Configure and load javascript adapter.
  #
  #  parameters:
  #  ===========
  #
  #  config: a hash with the folowing optional keys:
  #
  #     :adapter - The adapter to be used (defaults to 'extjs')
  #
  def self.load_adapter(config={})
    @@config.merge!(config)
    load "adapters/#{@@config[:adapter]}/adapter.rb"
  end

  #
  #  rwt_render
  #  ==========
  #
  #  Instead of the normal render, controllers using rwt should use rwt_render.
  #  rwt_render sends javascript code to be executed by the client (browser) to
  #  create/update the visual interface.
  #
  #  It looks in the views directory for a .rb or .js file corresponding to the
  #  action in the controller.
  #  
  #  The ruby views are treated as normal ruby files and are executed. The
  #  resulting code buffer is sent to client.
  #
  #  The javascript views are treated as .erb files with a small substitution
  #  before erb rendering:
  #    - '<% is changed to <%
  #    - %>' is changed to %>
  #  That is to say, in your javascript views you should use '<% .... %>' or
  #  "<% .... %>" when you want erb substitution. This way you don't harm the
  #  javascript syntax. "<% ... %>" sequences are passed without modification.
  #  
  #  Parameters:
  #  ===========
  #  
  #  inline: instead of using a view, use this string as template
  #  
  #  register_as: register this render with this name, so that the next time
  #               the client requests this action the local registered version 
  #               will be used (instead of requesting it again).
  #
  #TODO: investigate the possibility of implementing 'cached' instead of 'register_as' and use the url as the key to register
  #  cached: if the view is to be cached in client
  #
  def rwt_render(config={})
    inline= config.delete(:inline)
    type= config.delete(:type) || 'rb'
    register_as= config.delete(:register_as)

    if inline
      if type == 'rb'
        Rwt.clear
        Rwt << "jsret=(function(owner){"  # Encapsulate in a function passing an owner

        ret=eval(inline)

        Rwt << "});" # Close encapsulation function

        if ret.is_a?(Rwt::App)
          Rwt << "()"  # Imitiately executes
        else
          if register_as
            Rwt << "jsret.id='#{register_as}';" # Register in Rwt
          end
          Rwt << "jsret;"
        end

        render :text=> Rwt.code
      else
        Rwt.clear
        Rwt << "jsret=(function(owner){"
        Rwt << inline.gsub("'<%","<%").gsub("%>'","%>")
        Rwt << "});"
        if register_as
          Rwt << "jsret.id='#{register_as}';" # Register in Rwt
        end
        Rwt << "jsret;"
        render :text=> Rwt.code
      end
    else

      # Try to find a rwt template
      template=File.join(RAILS_ROOT,'app','views',params[:controller],params[:action])

      if File.exist?(template+'.rb')
        # If .rb found render javascript by evaluating the ruby code
        Rwt.clear
        Rwt << "jsret=(function(owner){"  # Encapsulate in a function passing an owner

        rbret=eval(File.open(template+'.rb').read)

        Rwt << "});" # Close encapsulation function

        if rbret.is_a?(Rwt::App)
          Rwt << "jsret();"  # Imitiately executes
        else
          if register_as
            Rwt << "jsret.id='#{register_as}';" # Register in Rwt
          end
          Rwt << "jsret;"
        end

        render :text=> Rwt.code

      elsif File.exist?(template+'.js')
        # If .js found render it as an normal erb ( <% %> should be inside single or double quotes)
        #  - single quotes are striped off
        #  - double quotes are passed as is
        Rwt.clear
        Rwt << "jsret=(function(owner){"
        Rwt << render_to_string(:inline=> File.open(template+'.js').read.gsub("'<%","<%").gsub("%>'","%>") )
        Rwt << "});"
        if register_as
          Rwt << "jsret.id='#{register_as}';" # Register in Rwt
        end
        Rwt << "jsret;"
        render :text=> Rwt.code
      end
    end
  end

#  def get_scope
#    binding
#  end

  #
  #  rwt_load
  #  ========
  #  
  #  Loads and evaluates a file from the same directory of the template
  #  
  #  Use (inside a rwt template)
  #  ===
  #  
  #  myHash= rwt_load('hash_values.rb')
  #
  #  or
  #  myHash= rwt_load('hash_values')
  #
  #  x= myHash[:mykey]
  #  ...
  #
  def rwt_load(file)
    filename=file
    if !filename.include?('.rb')
      filename+='.rb'
    end
    eval(File.open(File.join(RAILS_ROOT,'app','views',controller_name,filename)).read)
  end

  #
  #  rwt_ok
  #  ======
  #  
  #  Prepares a response to a post request, in the case of no errors
  #  found in the controller
  #  
  #  Use (in a controller)
  #  ===
  #  
  #  def update
  #    @post= Post.find(params[:id])
  #    if @post.update_attributes(params[:post])
  #      rwt_ok
  #    else
  #      rwt_message(@post.errors)
  #    end
  #  end
  #
  def rwt_ok(config={})
    config.merge!({:success=>true})
    render :text => config.to_json
  end

  #
  #  rwt_message
  #  ===========
  #  
  #  Prepares a response to a post request, in the case of errors
  #  found in the controller
  #  
  #  Use
  #  ===
  #  
  #  def update
  #    @post= Post.find(params[:id])
  #    if @post.update_attributes(params[:post])
  #      rwt_ok
  #    else
  #      rwt_message(@post.errors)
  #    end
  #  end
  #
  def rwt_message(message)
    case message
      when String
        msg= message
      when ActiveRecord::Errors
        msg= ''
        message.each do |key,errors|
          msg << "<b>#{key}: </b> "
          errors.each do |e|
            msg << "#{e}, "
          end
          msg << '<br>'
        end
      else
        msg= message.to_s
    end
    render :text => {:success=>true,:message=>msg}.to_json
  end

  #
  #  rwt_err_messages
  #  ================
  #  
  #  Prepares a response to a post request, in the case of errors
  #  found in the database operation
  #  
  #  Parameter
  #  =========
  #    - base instance
  #  
  #  Use
  #  ===
  #  
  #  def update
  #    @post= Post.find(params[:id])
  #    if @post.update_attributes(params[:post])
  #      rwt_ok
  #    else
  #      rwt_err_messages(@post)
  #    end
  #  end
  #
  def rwt_err_messages(base)
    case base
      when ActiveRecord::Base
        msg= ''
        base.errors.each do |key,errors|
          if base.class.respond_to?('titles') # Enable i18n, define @@titles in model
            key_title= base.class.titles[key.to_sym] || base.class.titles[key] || key.humanize
          else
            key_title= key.humanize
          end
          
          msg << "<b>#{key_title}: </b> "
          errors.each do |e|
            msg << "#{e}<br>"
          end
        end
    end
    render :text => {:success=>true,:message=>msg}.to_json
  end

  #
  #  explicit_js
  #  ===========
  #  
  #  Sends the javascript file corresponding to the action
  #  in the controller (app/views/controllerName/actionName.js)
  #  No templating is done.
  #  
  #  Use (in controller, deprecated)
  #  ===
  #  
  #  ...
  #  
  #  def actionName
  #    respond_to do |format|
  #      format.js {explicit_js}
  #    end
  #  end
  #
  def explicit_js
    js_file=File.join(RAILS_ROOT,'app','views',params[:controller],params[:action]+".js")
    javascript= File.open(js_file).read
    render :text=> javascript
  end

  #
  #  js_load
  #  =======
  #
  #  Minifies a javascript file and inserts in rwt buffer after processing it as an erb.
  #
  #  (similar to rwt_load in rb views, but for js views)
  #
  def js_load(file)
    filename=file
    if !filename.include?('.js')
      filename+='.js'
    end
#    js_erb=File.open(File.join(RAILS_ROOT,'app','views',controller_name,filename)).read.gsub("'<%","<%").gsub("%>'","%>")
    js_erb=File.open(File.join(RAILS_ROOT,'app','views',params[:controller],filename)).read.gsub("'<%","<%").gsub("%>'","%>")
#    Rwt.js(render_to_string(:inline=>js_erb))
    Rwt << render_to_string(:inline=>js_erb)
  end

  #
  #  message
  #  =======
  #
  #  Sends a message, using the Rwt.message javascript defined in the client application.
  #
  def message(message,title='Message')
    Rwt << "Rwt.message('#{title}','#{message}');"
  end



  #  The following code was copied from ext_scaffold, with small changes.

  #
  #  Copyright (c) 2008 martin.rehfeld@glnetworks.de
  #
  #  Permission is hereby granted, free of charge, to any person obtaining
  #  a copy of this software and associated documentation files (the
  #  "Software"), to deal in the Software without restriction, including
  #  without limitation the rights to use, copy, modify, merge, publish,
  #  distribute, sublicense, and/or sell copies of the Software, and to
  #  permit persons to whom the Software is furnished to do so, subject to
  #  the following conditions:
  #
  #  The above copyright notice and this permission notice shall be
  #  included in all copies or substantial portions of the Software.
  #
  #  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
  #  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
  #  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
  #  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
  #  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
  #  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
  #  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  def update_pagination_state_with_params!(restraining_model = nil)
    model_klass = (restraining_model.is_a?(Class) || restraining_model.nil? ? restraining_model : restraining_model.to_s.classify.constantize)
    pagination_state = previous_pagination_state(model_klass)
    pagination_state.merge!({
      :sort_field => (params[:sort] || pagination_state[:sort_field] || 'id').sub(/(\A[^\[]*)\[([^\]]*)\]/,'\2'), # fields may be passed as "object[attr]"
      :sort_direction => (params[:dir] || pagination_state[:sort_direction]).to_s.upcase,
      :offset => (params[:start] || pagination_state[:offset] || 0).to_i,
      :limit => (params[:limit] || pagination_state[:limit] || 9223372036854775807).to_i
    })
    # allow only valid sort_fields matching column names of the given model ...
    unless model_klass.nil? || model_klass.column_names.include?(pagination_state[:sort_field])
      pagination_state.delete(:sort_field)
      pagination_state.delete(:sort_direction)
    end
    # ... and valid sort_directions
    pagination_state.delete(:sort_direction) unless %w(ASC DESC).include?(pagination_state[:sort_direction])

    save_pagination_state(pagination_state, model_klass)
  end

  def options_from_pagination_state(pagination_state)
    find_options = { :offset => pagination_state[:offset],
                     :limit  => pagination_state[:limit] }
    find_options.merge!(
      :order => "#{pagination_state[:sort_field]} #{pagination_state[:sort_direction]}"
    ) unless pagination_state[:sort_field].blank?

    find_options
  end

  private

    # get pagination state from session
    def previous_pagination_state(model_klass = nil)
      session["#{model_klass.to_s.pluralize.underscore if model_klass}_pagination_state"] || {}
    end

    # save pagination state to session
    def save_pagination_state(pagination_state, model_klass = nil)
      session["#{model_klass.to_s.pluralize.underscore if model_klass}_pagination_state"] = pagination_state
    end



  # Utilities and components:
  require 'rwt/util'
  require 'rwt/array'
  require 'rwt/hash'
  require 'rwt/component'
  require 'rwt/app'
  require 'rwt/toolbar'
  require 'rwt/window'
  require 'rwt/button'
  require 'rwt/form'
  require 'rwt/field'
  require 'rwt/tabpanel'
  require 'rwt/fieldset'
  require 'rwt/dbgrid'
  require 'rwt/editform'
  require 'rwt/panel'
  require 'rwt/htmleditor'
  require 'rwt/container'

  # Load the default javascript adapter
  load_adapter

end