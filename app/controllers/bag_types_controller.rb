class BagTypesController < ApplicationController

  before_action :load_bag_type, only: [:edit, :update]

  def new
    @bag_type = BagType.new
  end

  def create
    @bag_type = BagType.new(bag_type_params)
    if @bag_type.save
      redirect_to bag_types_path, :notice => "You have successfully created a new bag type."
    else
      render :new
    end
  end

  def index
    @bag_types = BagType.all
  end

  def update
    if @bag_type.update(bag_type_params)
      redirect_to bag_types_path, :notice => "You have successfully updated a bag type"
    else
      render :edit
    end
  end

  def destroy
    BagType.destroy(params[:id])
    redirect_to bag_types_path, :notice => "You have successfully removed a bag type."
  end

  private
  def bag_type_params
    params.require(:bag_type).permit(:manufacturer, :description, :glucose_ml_percent_1_36, :glucose_ml_percent_2_27,
      :glucose_ml_percent_3_86, :amino_acid_ml, :icodextrin_acid_ml, :low_glucose_degradation, :low_sodium)
  end

  def load_bag_type
    @bag_type = BagType.find(params[:id])
  end
end
