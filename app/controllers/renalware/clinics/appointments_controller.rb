# frozen_string_literal: true

require_dependency "renalware/clinics"

module Renalware
  module Clinics
    class AppointmentsController < BaseController
      include Renalware::Concerns::Pageable

      def index
        appointments_query = AppointmentQuery.new(query_params)
        appointments = appointments_query.call.page(page).per(per_page)
        authorize appointments

        render :index, locals: {
          appointments: appointments,
          query: appointments_query.search,
          clinics: Clinic.ordered,
          users: User.ordered,
          request_html_form_params: build_params_for_html_form(appointments)
        }
      end

      def new
        render_new(Appointment.new)
      end

      def create
        appointment = Appointment.new(appointment_params)
        appointment.user = current_user
        authorize appointment
        if appointment.save
          redirect_to appointments_path, notice: t(".success", model_name: "Appointment")
        else
          render_new(appointment)
        end
      end

      private

      def render_new(appointment)
        authorize appointment
        render :new, locals: { appointment: appointment }
      end

      def build_params_for_html_form(appointments)
        OpenStruct.new(
          patient_ids: appointments.map(&:patient_id).uniq
        )
      end

      def query_params
        params.fetch(:q, {})
      end

      def appointment_params
        params
          .require(:clinics_appointment)
          .permit(:patient_id, :clinic_id, :starts_at)
      end
    end
  end
end
