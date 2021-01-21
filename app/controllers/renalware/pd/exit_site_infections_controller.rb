# frozen_string_literal: true

require_dependency "renalware/hd/base_controller"

module Renalware
  module PD
    class ExitSiteInfectionsController < BaseController
      include PresenterHelper
      include Renalware::Concerns::PdfRenderable
      skip_after_action :verify_policy_scoped

      def show
        authorize exit_site_infection
        respond_to do |format|
          format.html { render_show }
          format.js   { render_show }
          format.pdf  { render_esi_as_pdf_printout }
        end
      end

      def new
        esi = ExitSiteInfection.new
        authorize esi
        render_new(esi)
      end

      def create
        esi = ExitSiteInfection.new(exit_site_infection_params.merge!(patient_id: patient.id))
        authorize esi
        if esi.save
          redirect_to patient_pd_exit_site_infection_path(patient, esi),
                      notice: t(".success", model_name: "exit site infection")
        else
          flash.now[:error] = t(".failed", model_name: "exit site infection")
          render_new(esi)
        end
      end

      def edit
        authorize exit_site_infection
        render locals: locals
      end

      def update
        authorize exit_site_infection
        if exit_site_infection.update(exit_site_infection_params)
          redirect_to patient_pd_exit_site_infection_path(patient, exit_site_infection),
                      notice: t(".success", model_name: "exit site infection")
        else
          flash.now[:error] = t(".failed", model_name: "exit site infection")
          render_edit
        end
      end

      private

      def render_show
        render :show, locals: locals(exit_site_infection)
      end

      def render_esi_as_pdf_printout
        variables = {
          "patient" => Patients::PatientDrop.new(patient),
          "renal_patient" => Renal::PatientDrop.new(patient),
          "pd_patient" => PD::PatientDrop.new(patient)
        }
        render_liquid_template_to_pdf(template_name: "esi_printable_form",
                                      filename: pdf_filename,
                                      variables: variables)
      end

      def pdf_filename
        "#{patient.family_name}-#{patient.hospital_identifier.id}" \
        "-ESI-#{exit_site_infection.id}".upcase
      end

      def render_edit
        render :edit, locals: locals
      end

      def render_new(esi)
        render :new, locals: locals(esi)
      end

      def locals(esi = exit_site_infection)
        {
          patient: patient,
          exit_site_infection: esi,
          treatable: present(esi, Medications::TreatablePresenter),
          prescriptions: present(
            esi.prescriptions.ordered,
            Medications::PrescriptionPresenter
          )
        }
      end

      def exit_site_infection_params
        params
          .require(:pd_exit_site_infection)
          .permit(:diagnosis_date, :treatment, :outcome, :notes, :recurrent, :cleared,
                  :catheter_removed, clinical_presentation: [])
      end

      def load_exit_site_infection
        exit_site_infection
      end

      def exit_site_infection
        @exit_site_infection ||= ExitSiteInfection.find(params[:id])
      end
    end
  end
end
