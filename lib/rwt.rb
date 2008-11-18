require 'ext'
require 'rwt/simple_app'
require 'rwt/db_grid_window'
require 'rwt/db_edit_window'
require 'rwt/component'
require 'rwt/app'
require 'rwt/toolbar'
require 'rwt/window'
require 'rwt/form'
require 'rwt/text_field'
require 'rwt/button'
require 'rwt/db_grid'
require 'rwt/grid'
require 'rwt/dialog_window'
require 'rwt/action_view/helpers/active_record_helper'
#
#  Rails Web Toolkit - Copyright (c) 2008 accesstecnologia.com.br
#  
#  Rwt is a visual web framework built on top of ExtJS javascript library.
# 
#  The Rwt module should be included in the application controller or 
#  installed using the rwt plugin (see ...)
#
module Rwt
  #
  # Rwt exceptions
  #
  class MissingParameter < StandardError; end
  
  #
  #  message
  #  =======
  #  
  #  Pops up a window with title and message
  #  
  def self.message(title='',message='')
    function("Ext.Msg.alert('#{title}','#{message}');")
  end
  def message(title='',message='')
    function("Ext.Msg.alert('#{title}','#{message}');")
  end
  
  #
  #  rb_template
  #  ===========
  #  
  #  Executes the ruby template corresponding to the
  #  action in the controller (app/views/controllerName/actionName.rb)
  #  
  #  Use
  #  ===
  #  
  #  def actionName
  #    respond_to do |format|
  #      format.js {render :text => rb_template}
  #    end
  #  end
  #
  def rb_template
    template=File.join(RAILS_ROOT,'app','views',params[:controller],params[:action]+".rb")
    code= eval(File.open(template).read)
    if code.respond_to?('render')
      code.render
    else
      code
    end
  end

  #
  #  rwt_template    (a shorter form of rb_template)
  #  ============
  #  
  #  Executes the ruby template corresponding to the action in the
  #  controller (app/views/controllerName/actionName.rb)
  #  
  #  Use
  #  ===
  #  
  #  def actionName
  #    respond_to do |format|
  #      format.js {rwt_template}
  #    end
  #  end
  #
  def rwt_template
    render :text=> rb_template
  end
  
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
  #  Use (in the controller)
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

#-
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
          if base.class.respond_to?('titles')
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
#-
  #
  #  explicit_js
  #  ===========
  #  
  #  Sends the javascript file corresponding to the action
  #  in the controller (app/views/controllerName/actionName.js)
  #  No templating is done.
  #  
  #  Use (in controller)
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
  #  form_line
  #  =========
  #
  #  Returns a hash corresponding to a line in a form with lines formed with
  #  column layout (each field in a column inside the line)
  # 
  #  parameters:
  #  ===========
  #   fields: a hash with the fields to put in the form
  #   config: a hash with the configuration of the line in the form
  #        {:field_name1=>field_width1, :field_name2=>field_width2,....}
  #   padding_top: top padding of the line (in px)
  #   padding_left: left padding of each field (in px), defaults to 20
  #   padding_botton: botton padding of each line
  #   
  #  Example of use:
  #  ===============
  #  fields={
  #   :t1=>{:xtype=>'textfield',:fieldLabel=>'test1'},
  #   :t2=>{:xtype=>'textfield',:fieldLabel=>'test2'},
  #   :t3=>{:xtype=>'textfield',:fieldLabel=>'test3'},
  #   :b4=>{:xtype=>'button',:text=>'teste', :handler=>function("alert('a button')")}
  #   }
  #  tab={
  #   :title=>'A tab inside a TabPanel',
  #   :xtype=>'form',
  #   :labelAlign=>'top',
  #
  #   :items=>[
  #          form_line(fields,[{:t1=>300},{:t2=>200}],10),   # a top_padding of 10 in the first line
  #          form_line(fields,[{:t3=>500}]),
  #          form_line(fields,[{:b4=>70}])
  #          ]
  #   }
  #
  def form_line(fields={},config=[],padding_top=0,padding_left=10,padding_botton=0)
    items=[]
    config.each do |field|
      begin
        field.each do |name,width|
          items << {:width=>width,:items=>fields[name].merge(:width=>width-padding_left)}
        end
      rescue
        items << {:width=>200,:items=>{:xtype=>'label',:text=>"Incorrect field specification!",:width=>180}}
      end
    end
    { :layout=>'column',
      :border=>false,
      :defaults=>{:layout=>'form',:border=>false,
                  :bodyStyle=>"padding:#{padding_top}px 0px #{padding_botton}px #{padding_left}px"},
      :items=>items
    }
  end

  #  The following code was copied from ext_scaffold:

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
end
