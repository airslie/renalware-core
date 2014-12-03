class DrugsController < ApplicationController

  def search
   
    @search = params[:drug_search]   
    @drugs = Drug.search("#{@search}*").records
    respond_to do |format|
      format.html
      format.json { render :json => @drugs.as_json(:only => [:id, :name]) }
    end
    # render :template => 'drugs/index'
  end 

  def new
    @drug = Drug.new
  end

  def create
    @drug = Drug.new(allowed_params)
    if @drug.save
      redirect_to drugs_path, :notice => "You have successfully added a new drug."
    else
      render :new
    end
  end

  def index
    @drugs = Drug.all
    @drugs_select = Drug.where(:type => params[:medication_type])
    respond_to do |format|
      format.html
      format.json { render :json => @drugs_select.as_json(:only => [:id, :name]) }
    end
  end

  def edit
    @drug = Drug.find(params[:id])
  end

  def update
    @drug = Drug.find(params[:id])
    if @drug.update(allowed_params)
      redirect_to drugs_path, :notice => "You have successfully updated a drug"
    else
      render :edit
    end
  end

  def destroy
    @drug = Drug.find(params[:id])
    @drug.soft_delete!
    redirect_to drugs_path, :notice => "You have successfully removed a drug."
  end

  private
  def allowed_params
    params.require(:drug).permit(:name, :type, :deleted_at)
  end

end
