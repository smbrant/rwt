require 'active_record'
require 'action_controller'
module Rwt
  #  Rwt::DbGrid
  #  ===========
  #
  #  Database grid.
  #
  #  Config parameters:
  #  ==================
  #
  #   :model -
  #   :controller -
  #   :authenticity_token -
  #   :pageSize -   number of records per page (defaults to 8)
  #   :filter -     defaults to true, enables/disables the filtering field
  #   :readOnly -   defaults to false, if true inhibit modifications
  #   :show_new_btn - true/false, force to show/hide new button
  #   :show_edit_btn - true/false, force to show/hide edit button
  #   :show_delete_btn - true/false, force to show/hide delete button
  #   :id - an id to insert as a parameter in the json get (optional)
  #   :json_params - a hash of parameters to send with the json request
  #   :adv_search_view - url to adv_search view
  #
  #  Use
  #  ===
  #
  def dbgrid(*config,&block)
    DbGrid.new(*config,&block)
  end

  class DbGrid < Rwt::Component

    attr_accessor :model
    attr_accessor :controller

    def init_default_par(non_hash_params)
       @config[:model]=non_hash_params[0] if non_hash_params[0] #.is_a?(ActiveRecord::Base)
       @config[:controller]= non_hash_params[1] if non_hash_params[1] #.is_a?(ActionController::Base)
       @config[:authenticity_token]= non_hash_params[2] if non_hash_params[2]
    end

    def init_cmp
      @model= @config[:model] || nil
      puts @model
      @controller= @config[:controller] || nil
      @title= @config[:title] || ''
      @authenticity_token= @config[:authenticity_token] ||''
      @width= @config[:width] || 500
      @height= @config[:height] || 300
      @hideId= if @config.key?(:hideId)
                  @config[:hideId]
                else
                  true
                end
      @page_size= @config[:pageSize] || 8
      @filter= if @config.key?(:filter)
                  @config[:filter]
                else
                  true
                end
      @read_only= if @config.key?(:readOnly)
                  @config[:readOnly]
                else
                  false
                end
      @print= if @config.key?(:print)
                  @config[:print]
                else
                  false
                end
      @id = @config[:id] || nil
      @json_params= @config[:json_params] || nil
      @adv_search_view= @config[:adv_search_view] || nil

      @show_new_btn= if @config.key?(:show_new_btn)
                  @config[:show_new_btn]
                else
                  false
                end
      @show_edit_btn= if @config.key?(:show_edit_btn)
                  @config[:show_edit_btn]
                else
                  false
                end
      @show_delete_btn= if @config.key?(:show_delete_btn)
                  @config[:show_delete_btn]
                else
                  false
                end
    end

    def json_params
      params=''
      if @json_params
        @json_params.each do |key,value|
          params << "&#{key.to_s}=#{value.to_s}"
        end
      end
      return params
    end

  end
end
