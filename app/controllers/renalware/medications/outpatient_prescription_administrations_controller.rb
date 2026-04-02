module Renalware
  module Medications
    class OutpatientPrescriptionAdministrationsController < BaseController
      include Renalware::Concerns::PatientVisibility

      before_action :find_and_load_patient_from_prescription, except: :index

      def index
        administrations = filter_by_drug_name(
          patient
          .outpatient_prescription_administrations
          .includes(:administered_by, :witnessed_by, :reason, prescription: :drug)
        )
          .ordered
        authorize administrations

        pagy, administrations = pagy(administrations)

        render locals: {
          drug_name_options: administered_drug_names,
          outpatient_prescription_administrations: administrations,
          pagy:,
          patient:,
          selected_drug_name:
        }
      end

      def new
        administration = patient.outpatient_prescription_administrations.build(
          prescription: prescription,
          administered_by: current_user,
          recorded_on: Date.current
        )
        render_new(administration)
      end

      def create
        administration = patient.outpatient_prescription_administrations.build(
          outpatient_prescription_administration_parameters
        )
        clear_irrelevant_attributes_if_drug_was_not_administered(administration)
        authorize administration

        if administration.save_by(current_user)
          # will render create.js
        else
          render_new(administration)
        end
      end

      def destroy
        administration = OutpatientPrescriptionAdministration
          .where(prescription:)
          .find(params[:id])
        authorize administration

        administration.destroy!
        redirect_to patient_medications_outpatient_prescription_administrations_path(
          administration.patient
        )
      end

      private

      def clear_irrelevant_attributes_if_drug_was_not_administered(administration)
        return if administration.administered

        administration.administered_by = nil
        administration.witnessed_by = nil
      end

      def prescription
        @prescription ||= Prescription.find_by(
          id: params[:prescription_id],
          give_as_outpatient: true
        )
      end

      def selected_drug_name
        params[:drug_name].presence
      end

      def administered_drug_names
        patient
          .outpatient_prescription_administrations
          .where(administered: true)
          .joins(prescription: :drug)
          .distinct
          .order("drugs.name asc")
          .pluck("drugs.name")
      end

      def filter_by_drug_name(scope)
        return scope if selected_drug_name.blank?

        scope
          .joins(prescription: :drug)
          .where(drugs: { name: selected_drug_name })
      end

      def find_and_load_patient_from_prescription
        @patient = patient_scope.find(prescription&.patient_id)
      end

      def render_new(administration)
        authorize administration
        render(
          :new,
          locals: { outpatient_prescription_administration: administration },
          layout: false
        )
      end

      def outpatient_prescription_administration_parameters
        params
          .require(:medications_outpatient_prescription_administration)
          .permit(
            [
              :administered,
              :prescription_id,
              :notes,
              :reason_id,
              :administered_by_id,
              :witnessed_by_id,
              :administered_by_password,
              :witnessed_by_password,
              :skip_witness_validation,
              :recorded_on
            ]
          )
      end
    end
  end
end
