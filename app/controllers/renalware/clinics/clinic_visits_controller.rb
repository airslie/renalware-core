# frozen_string_literal: true

module Renalware
  module Clinics
    class ClinicVisitsController < BaseController
      before_action :load_patient
      before_action :load_clinic_visit, only: [:edit, :update, :destroy]

      def index
        visits = patient.clinic_visits.includes([:clinic, :created_by]).ordered
        render locals: {
          patient: patient,
          clinic_visits: CollectionPresenter.new(visits, ClinicVisitPresenter)
        }
      end

      def new
        clinic_visit = build_new_clinic_visit
        RememberedClinicVisitPreferences.new(session).apply_to(clinic_visit)

        render :new, locals: {
          patient: patient,
          clinic_visit: clinic_visit,
          built_from_appointment: appointment_to_build_from
        }
      end

      def create
        result = CreateClinicVisit.call(patient, visit_params)
        visit = result.object.clinic_visit
        appointment = result.object.appointment_to_build_from

        if result.success?
          RememberedClinicVisitPreferences.new(session).persist(visit)
          notice = success_msg_for("clinic visit")
          redirect_to patient_clinic_visits_path(patient), notice: notice
        else
          flash.now[:error] = failed_msg_for("clinic visit")
          render :new, locals: {
            patient: patient,
            clinic_visit: visit,
            built_from_appointment: appointment
          }
        end
      end

      def update
        if @clinic_visit.update(visit_params)
          redirect_to patient_clinic_visits_path(@patient),
            notice: t(".success", model_name: "clinic visit")
        else
          flash.now[:error] = t(".failed", model_name: "clinic visit")
          render :edit
        end
      end

      def destroy
        @clinic_visit.destroy
        redirect_to patient_clinic_visits_path(@patient),
          notice: t(".success", model_name: "clinic visit")
      end

      private

      def build_new_clinic_visit
        attrs = { height: last_height_measurement }
        if appointment_to_build_from.present?
          BuildVisitFromAppointment.new(appointment_to_build_from).call(attrs)
        else
          patient.clinic_visits.new(attrs)
        end
      end

      def last_height_measurement
        last_visit = @patient.clinic_visits.order(created_at: :desc).first
        last_visit&.height
      end

      def appointment_to_build_from
        @appointment_to_build_from ||= begin
          appointment_id = params[:appointment_id]
          patient.appointments.find(appointment_id) if appointment_id.present?
        end
      end

      def load_patient
        super
        @patient = Renalware::Clinics.cast_patient(@patient)
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

      def load_clinic_visit
        @clinic_visit = ClinicVisit.find(params[:id])
      end
    end
  end
end
