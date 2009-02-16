class RwtTestController < ApplicationController
  before_filter :normal_render, :except=>[:index]

  def index
    respond_to do |format|
      format.html               # a normal html.erb template
      format.js {rwt_template}  # a rwt template
    end
  end
  
  private
  def normal_render
    rwt_template
  end
end
