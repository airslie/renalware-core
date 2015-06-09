class PdRegimesController < ApplicationController

  # Cancancan authorization filter
  load_and_authorize_resource

  before_filter :find_patient

  def new
    @pd_regime = PdRegime.new(patient: @patient)
  end

  def create
    @pd_regime = PdRegime.new(pd_regime_params)
    if perform_action
      redirect_to pd_info_patient_path(@patient), notice:"You have successfully added a PD Regime."
    else
      render :new
    end
  end

  private

  def pd_regime_params
    params.require(:pd_regime).permit(:patient_id, :start_date, :end_date,
      :glucose_ml_percent_1_36, :glucose_ml_percent_2_27, :glucose_ml_percent_3_86, :amino_acid_ml,
      :icodextrin_ml, :low_glucose_degradation, :low_sodium, :additional_hd,
      pd_regime_bags_attributes: [:bag_type_id, :volume, :per_week, :monday, :tuesday, :wednesday,
                                  :thursday, :friday, :saturday, :sunday])
  end

  def find_patient
    @patient = Patient.find(params[:patient_id])
  end

  def perform_action
    case params[:commit]
    when 'Add Bag'
      @pd_regime.pd_regime_bags.build; false
    else
      @pd_regime.save
    end
  end
end
