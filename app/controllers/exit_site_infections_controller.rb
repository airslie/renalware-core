class ExitSiteInfectionsController < ApplicationController

  before_action :load_patient, :only => [:new, :create]

  def new
    @exit_site_infection = ExitSiteInfection.new
    @exit_site_infection.infection_organisms.build
    @exit_site_infection.medications.build(provider: :gp)
  end

  def create
    @exit_site_infection = ExitSiteInfection.new(allowed_params)
    @exit_site_infection.patient_id = @patient.id
    if @exit_site_infection.save
      redirect_to pd_info_patient_path(@patient), :notice => "You have successfully added a peritonitis episode."
    else
      render :new
    end
  end

  def edit
    @patient = Patient.find(params[:id])
    @exit_site_infection = ExitSiteInfection.find(params[:id])
  end

  def update
    @patient = Patient.find(params[:id])
    @exit_site_infection = ExitSiteInfection.find(params[:id])
    if @exit_site_infection.update(allowed_params)
      redirect_to pd_info_patient_path(@patient),
      :notice => "You have successfully updated an exit site infection."
    else
      render :edit
    end
  end

  private
  def allowed_params
    params.require(:exit_site_infection).permit(:diagnosis_date, :treatment, :outcome, :notes,
      :infection_organisms_attributes => [:id, :organism_code_id, :sensitivity, :infectable_id, :infectable_type ],
      :medications_attributes => [:id, :patient_id, :treatable_id, :treatable_type, :medicatable_id, :medicatable_type,
      :dose, :medication_route_id, :frequency, :notes, :date, :provider, :_destroy])
  end

  def load_patient
    @patient = Patient.find(params[:patient_id])
  end

end
