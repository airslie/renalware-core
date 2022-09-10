# frozen_string_literal: true

module Renalware
  module Clinics
    class ClinicVisitsController < BaseController
      include Renalware::Concerns::PatientCasting
      include Renalware::Concerns::PatientVisibility

      def index
        visits = clinics_patient.clinic_visits.includes([:clinic, :created_by]).ordered
        authorize visits
        render locals: {
          patient: clinics_patient,
          clinic_visits: CollectionPresenter.new(visits, ClinicVisitPresenter)
        }
      end

      def new
        clinic_visit = build_new_clinic_visit
        authorize clinic_visit
        RememberedClinicVisitPreferences.new(session).apply_to(clinic_visit)

        render :new, locals: {
          patient: clinics_patient,
          clinic_visit: clinic_visit,
          built_from_appointment: appointment_to_build_from
        }
      end

      def create
        authorize ClinicVisit, :create?
        result = CreateClinicVisit.call(clinics_patient, visit_params)
        visit = result.object.clinic_visit
        appointment = result.object.appointment_to_build_from

        if result.success?
          RememberedClinicVisitPreferences.new(session).persist(visit)
          notice = success_msg_for("clinic visit")
          redirect_to patient_clinic_visits_path(clinics_patient), notice: notice
        else
          flash.now[:error] = failed_msg_for("clinic visit")
          render :new, locals: {
            patient: clinics_patient,
            clinic_visit: visit,
            built_from_appointment: appointment
          }
        end
      end

      def edit
        render_edit(find_and_authorize_clinic_visit)
      end

      def update
        clinic_visit = find_and_authorize_clinic_visit
        if clinic_visit.update(visit_params)
          redirect_to patient_clinic_visits_path(clinics_patient),
                      notice: success_msg_for("clinic visit")
        else
          flash.now[:error] = failed_msg_for("clinic visit")
          render_edit(clinic_visit)
        end
      end

      def destroy
        find_and_authorize_clinic_visit.destroy
        redirect_to patient_clinic_visits_path(clinics_patient),
                    notice: success_msg_for("clinic visit")
      end

      private

      def render_edit(visit)
        render :edit, locals: { patient: clinics_patient, clinic_visit: visit }
      end

      def build_new_clinic_visit
        attrs = { height: last_height_measurement }
        if appointment_to_build_from.present?
          BuildVisitFromAppointment.new(appointment_to_build_from).call(attrs)
        else
          clinics_patient.clinic_visits.new(attrs)
        end
      end

      def last_height_measurement
        last_visit = clinics_patient.clinic_visits.order(created_at: :desc).first
        last_visit&.height
      end

      def appointment_to_build_from
        @appointment_to_build_from ||= begin
          appointment_id = params[:appointment_id]
          clinics_patient.appointments.find(appointment_id) if appointment_id.present?
        end
      end

      def visit_params
        @visit_params ||= begin
          params.require(:clinic_visit).permit(
            :date, :time, :clinic_id, :height, :weight, :pulse, :temperature,
            :bp, :standing_bp, :urine_blood, :urine_protein, :notes,
            :admin_notes, :did_not_attend, :built_from_appointment_id
          ).to_h.merge(by: current_user)
        end
      end

      def find_and_authorize_clinic_visit
        @clinic_visit = clinics_patient.clinic_visits.find(params[:id]).tap { |cv| authorize cv }
      end
    end
  end
end
