class DrugsController < ApplicationController

  include Pageable

  before_filter :prepare_drugs_search, only: [:index, :search]
  before_filter :prepare_paging, only: [:index]

  def selected_drugs
    @medication_switch = params[:medication_switch]
    @selected_drugs = Drug.send(@medication_switch)
    respond_to do |format|
      format.html
      format.json { render :json => @selected_drugs.as_json(:only => [:id, :name]) }
    end
  end

  def search
    @drugs = @drugs_search.result
    respond_to do |format|
      format.html
      format.json { render :json => @drugs.as_json(:only => [:id, :name]) }
    end
  end

  def new
    @drug = Drug.new
    @drug_types = DrugType.all
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
    @drugs = @drugs_search.result.page(@page).per(@per_page)
  end

  def edit
    @drug = Drug.find(params[:id])
    @drug_drug_types = @drug.drug_drug_types
    @drug_types = DrugType.all
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
    Medication.where(medicatable_id: @drug.to_param).each { |pm| pm.soft_delete! }
    redirect_to drugs_path, :notice => "You have successfully removed a drug."
  end

  private
  def allowed_params
    params.require(:drug).permit(:name, :deleted_at, :drug_type_ids => [])
  end

  def prepare_drugs_search
    search_params = { active: true }.merge(params.fetch(:q, {}))
    @drugs_search = Drug.ransack(search_params)
    @drugs_search.sorts = 'name'
  end
end
