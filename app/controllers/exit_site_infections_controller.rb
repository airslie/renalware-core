class ExitSiteInfectionsController < ApplicationController

  before_action :load_patient, only: [:new, :create, :show, :edit, :update]
  before_action :load_exit_site_infection, only: [:show, :edit, :update]
  # Cancancan authorization filter
  load_and_authorize_resource

  def new
    @exit_site_infection = ExitSiteInfection.new
    @exit_site_infection.infection_organisms.build
    @exit_site_infection.medications.build(provider: :gp)
  end

  def create
    @exit_site_infection = ExitSiteInfection.new(exit_site_infection_params)
    @exit_site_infection.patient_id = @patient.id
    if @exit_site_infection.save
      redirect_to pd_info_patient_path(@patient), :notice => "You have successfully added a peritonitis episode."
    else
      render :new
    end
  end

  def edit
    @exit_site_infection.medications.build(provider: :gp)
    @exit_site_infection.infection_organisms.build
  end

  def update
    if @exit_site_infection.update(exit_site_infection_params)
      redirect_to pd_info_patient_path(@patient),
      :notice => "You have successfully updated an exit site infection."
    else
      render :edit
    end
  end

  private
  def exit_site_infection_params
    params.require(:exit_site_infection).permit(:diagnosis_date, :treatment, :outcome, :notes,
      :infection_organisms_attributes => [:id, :organism_code_id, :sensitivity, :infectable_id, :infectable_type ],
      :medications_attributes => [:id, :patient_id, :treatable_id, :treatable_type, :medicatable_id, :medicatable_type,
      :dose, :medication_route_id, :frequency, :notes, :date, :provider, :_destroy])
  end

  def load_patient
    @patient = Patient.find(params[:patient_id])
  end

  def load_exit_site_infection
    @exit_site_infection = ExitSiteInfection.find(params[:id])
  end

end
