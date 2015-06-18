class PdRegimesController < RenalwareController
  include NestedActionsControllerMethods

  before_action :load_patient
  before_action :find_pd_regime, only: [:edit, :update, :show]

  def new
    @pd_regime = PdRegime.new(patient: @patient)
  end

  def create
    @pd_regime = PdRegime.new(pd_regime_params)
    if perform_action(pd_regime_bags, Proc.new { @pd_regime.save }, pd_regime: @pd_regime)
      redirect_to pd_info_patient_path(@patient), notice:"You have successfully added a PD Regime."
    else
      render :new
    end
  end

  def update
    if perform_action(pd_regime_bags, Proc.new { @pd_regime.update(pd_regime_params) }, pd_regime: @pd_regime)
      redirect_to pd_info_patient_path(@patient), :notice => "You have successfully updated a PD Regime."
    else
      render :edit
    end
  end

  private

  def pd_regime_params
    params.require(:pd_regime).permit(:patient_id, :start_date, :end_date,
      :glucose_ml_percent_1_36, :glucose_ml_percent_2_27, :glucose_ml_percent_3_86, :amino_acid_ml,
      :icodextrin_ml, :low_glucose_degradation, :low_sodium, :additional_hd,
      pd_regime_bags_attributes: [:id, :bag_type_id, :volume, :per_week, :monday, :tuesday,
                                  :wednesday, :thursday, :friday, :saturday, :sunday])
  end

  def find_pd_regime
    @pd_regime = PdRegime.find(params[:id])
  end

  def pd_regime_bags
    @pd_regime.pd_regime_bags
  end
end
