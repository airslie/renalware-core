class PdRegimesController < ApplicationController

  # Cancancan authorization filter
  load_and_authorize_resource

  before_filter :find_patient

  def new
    @pd_regime = PdRegime.new
  end

  def create
    @pd_regime = PdRegime.new(pd_regime_params)
    @pd_regime.patient_id = @patient.id
    if @pd_regime.save
      redirect_to pd_info_patient_path(@patient), :notice => "You have successfully added a PD Regime."
    else
      render :new
    end
  end

  private

  def pd_regime_params
    params.require(:pd_regime).permit(:user_id, :patient_id, :start_date, :end_date,
      :glucose_ml_percent_1_36, :glucose_ml_percent_2_27, :glucose_ml_percent_3_86, :amino_acid_ml,
      :icodextrin_ml, :low_glucose_degradation, :low_sodium, :additional_hd)
  end

  def find_patient
    @patient = Patient.find(params[:patient_id])
  end

end
