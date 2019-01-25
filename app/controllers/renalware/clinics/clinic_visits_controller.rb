# frozen_string_literal: true

module Renalware
  module Clinics
    class ClinicVisitsController < Clinics::BaseController
      def index
        visits = patient.clinic_visits.includes([:clinic, :created_by]).ordered
        authorize visits
        render locals: {
          patient: patient,
          clinic_visits: CollectionPresenter.new(visits, ClinicVisitPresenter)
        }
      end

      def new
        clinic_visit = build_new_clinic_visit
        authorize clinic_visit
        RememberedClinicVisitPreferences.new(session).apply_to(clinic_visit)
        render_new(clinic_visit, appointment_to_build_from)
      end

      # rubocop:disable Metrics/AbcSize
      def create
        result = CreateClinicVisit.call(patient, visit_params)
        visit = result.object.clinic_visit
        appointment = result.object.appointment_to_build_from
        authorize visit

        if result.success?
          RememberedClinicVisitPreferences.new(session).persist(visit)
          notice = success_msg_for("clinic visit")
          redirect_to patient_clinic_visits_path(patient), notice: notice
        else
          flash.now[:error] = failed_msg_for("clinic visit")
          render_new(visit, appointment)
        end
      end
      # rubocop:enable Metrics/AbcSize

      def edit
        render_edit(find_and_authorize_visit)
      end

      def update
        visit = find_and_authorize_visit
        if visit.update(visit_params)
          redirect_to patient_clinic_visits_path(patient),
                      notice: t(".success", model_name: "clinic visit")
        else
          flash.now[:error] = t(".failed", model_name: "clinic visit")
          render_edit(visit)
        end
      end

      def destroy
        find_and_authorize_visit.destroy
        redirect_to patient_clinic_visits_path(patient),
                    notice: t(".success", model_name: "clinic visit")
      end

      private

      def render_new(visit, appointment)
        render_template(:new, visit, appointment)
      end

      def render_edit(visit)
        render_template(:edit, visit)
      end

      def render_template(template, visit, appointment = nil)
        render template, locals: {
          patient: patient,
          clinic_visit: visit,
          built_from_appointment: appointment,
          clinic_options: clinic_options
        }
      end

      def build_new_clinic_visit
        attrs = { height: last_height_measurement }
        if appointment_to_build_from.present?
          BuildVisitFromAppointment.new(appointment_to_build_from).call(attrs)
        else
          new_clinic_visit(attrs)
        end
      end

      def new_clinic_visit(initial_attrs)
        visit = clinic_visit_class.new(initial_attrs)
        visit.patient = patient
        visit.clinic = clinic
        authorize visit
        visit
      end

      def clinic
        return Clinic.find(clinic_id) if clinic_id.present?

        Clinic.new
      end

      # Passed in as an arg when refreshing inputs after clinic dropdown changed
      def clinic_id
        @clinic_id ||= begin
          return visit_params[:clinic_id] if params[:clinic_visit]

          params[:clinic_id]
        end
      end

      def clinic_visit_class
        return ClinicVisit if clinic.visit_class_name.blank?

        clinic.visit_class_name.constantize
      end

      def last_height_measurement
        last_visit = patient.clinic_visits.order(created_at: :desc).first
        last_visit&.height
      end

      def appointment_to_build_from
        @appointment_to_build_from ||= begin
          appointment_id = params[:appointment_id]
          patient.appointments.find(appointment_id) if appointment_id.present?
        end
      end

      def visit_params
        @visit_params ||= begin
          params.require(:clinic_visit).permit(
            :date, :time, :clinic_id, :height, :weight, :pulse, :temperature,
            :bp, :standing_bp, :urine_blood, :urine_protein, :notes,
            :admin_notes, :did_not_attend, :built_from_appointment_id, document: {}
          ).to_h.merge(by: current_user)
        end
      end

      def clinic_options
        Renalware::Clinics::Clinic.order(:name).map do |clinic|
          url = if clinic.visit_class_name.present?
                  new_patient_clinic_visit_url(patient, clinic_id: clinic.id)
                else
                  new_patient_clinic_visit_url(patient)
                end
          [
            clinic.name,
            clinic.id,
            {
              data: { refresh_url: url }
            }
          ]
        end
      end

      def find_and_authorize_visit
        patient.clinic_visits.find(params[:id]).tap do |visit|
          authorize visit
        end
      end
    end
  end
end
