class PdRegimesController < ApplicationController

  # Cancancan authorization filter
  load_and_authorize_resource

  before_action :find_patient
  before_action :find_pd_regime, only: [:edit, :update]

  def new
    @pd_regime = PdRegime.new(patient: @patient)
  end

  def create
    @pd_regime = PdRegime.new(pd_regime_params)
    if @pd_regime.save
      redirect_to pd_info_patient_path(@patient), :notice => "You have successfully added a PD Regime."
    else
      render :new
    end
  end

  def update
    if @pd_regime.update(pd_regime_params)
      redirect_to pd_info_patient_path(@patient), :notice => "You have successfully updated a PD Regime."
    else
      render :edit
    end
  end

  private
  def pd_regime_params
    params.require(:pd_regime).permit(:patient_id, :start_date, :end_date,
      :glucose_ml_percent_1_36, :glucose_ml_percent_2_27, :glucose_ml_percent_3_86, :amino_acid_ml,
      :icodextrin_ml, :low_glucose_degradation, :low_sodium, :additional_hd)
  end

  def find_patient
    @patient = Patient.find(params[:patient_id])
  end

  def find_pd_regime
    @pd_regime = PdRegime.find(params[:id])
  end

end
