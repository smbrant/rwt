class <%= controller_class_name %>Controller < ApplicationController

  # GET /<%= table_name %>.xml
  # GET /<%= table_name %>.rwt
  def index
    respond_to do |format|
      format.xml  { render :xml => <%= class_name %>.find(:all) }
      format.rwt  { rwt_render }
      format.json do
        @page= <%= class_name %>.find(:all, :limit => params[:limit], :offset => params[:start])
        rwt_ok(:rows=>rwt_json(@page),:count=><%= class_name %>.count)
      end
    end
  end

  # GET /<%= table_name %>/1.xml
  # GET /<%= table_name %>/1.rwt
  def show
    @<%= file_name %> = <%= class_name %>.find(params[:id])
    respond_to do |format|
      format.xml  { render :xml => @<%= file_name %> }
      format.rwt { rwt_render }
    end
  end

  # GET /<%= table_name %>/new.xml
  # GET /<%= table_name %>/new.rwt
  def new
    @<%= file_name %> = <%= class_name %>.new
    respond_to do |format|
      format.xml  { render :xml => @<%= file_name %> }
      format.rwt  { rwt_render }
    end
  end

  # GET /<%= table_name %>/1/edit.rwt
  def edit
    @<%= file_name %> = <%= class_name %>.find(params[:id])
    respond_to do |format|
      format.rwt { rwt_render }
    end
  end

  # POST /<%= table_name %>.xml
  # POST /<%= table_name %>.rwt
  def create
    @<%= file_name %> = <%= class_name %>.new(params[:<%= file_name %>])
    respond_to do |format|
      if @<%= file_name %>.save
        format.xml  { render :xml => @<%= file_name %>, :status => :created, :location => @<%= file_name %> }
        format.rwt  { rwt_ok }
      else
        format.xml  { render :xml => @<%= file_name %>.errors, :status => :unprocessable_entity }
        format.rwt  { rwt_err_messages(@<%= file_name %>) }
      end
    end
  end

  # PUT /<%= table_name %>/1.xml
  # PUT /<%= table_name %>/1.rwt
  def update
    @<%= file_name %> = <%= class_name %>.find(params[:id])
    respond_to do |format|
      if @<%= file_name %>.update_attributes(params[:<%= file_name %>])
        format.xml  { head :ok }
        format.rwt  { rwt_ok }
      else
        format.xml  { render :xml => @<%= file_name %>.errors, :status => :unprocessable_entity }
        format.rwt  { rwt_err_messages(@<%= file_name %>) }
      end
    end
  end

  # DELETE /<%= table_name %>/1.xml
  # DELETE /<%= table_name %>/1.rwt
  def destroy
    @<%= file_name %> = <%= class_name %>.find(params[:id])
    @<%= file_name %>.destroy

    respond_to do |format|
      format.xml  { head :ok }
      format.rwt  { rwt_ok }
    end
  end

end
