require 'active_record'
require 'action_controller'
module Rwt
  #  Rwt::EditForm
  #  =============
  #
  #  Database grid.
  #
  #  Config parameters:
  #  ==================
  #
  #   :model_data -
  #   :controller -
  #   :authenticity_token -
  #   :id -         the id of record. If nil, create a new record
  #   :label_width-  label width
  #
  #  Use
  #  ===
  #
  def editform(*config,&block)
    EditForm.new(*config,&block)
  end

  class EditForm < Rwt::Component

#    attr_accessor :model_data
#    attr_accessor :controller

    def init_default_par(non_hash_params)
       @config[:model_data]=non_hash_params[0] if non_hash_params[0] #.is_a?(ActiveRecord::Base)
       @config[:controller]= non_hash_params[1] if non_hash_params[1] #.is_a?(ActionController::Base)
       @config[:authenticity_token]= non_hash_params[2] if non_hash_params[2]
    end

    def init_cmp
      @model= @config[:model_data].class || nil
      @controller= @config[:controller] || nil
#      @fields= @config[:fields] || @model.column_names
      @authenticity_token= @config[:authenticity_token] ||''
      @width= @config[:width] || owner.config[:width]-10
      @height= @config[:height] || owner.config[:height]-50
      @model_data= @config[:model_data] || nil
      @id= @config[:id] || nil  # TODO: raise exception for all necessary parameters...
      @label_width= @config[:label_width] || 120
    end

  end
end
