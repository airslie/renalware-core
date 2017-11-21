require_dependency "renalware/patients"

module Renalware
  module Patients
    class AlertsController < BaseController
      # GET html
      def new
        alert = Alert.new
        authorize alert
        render_form(alert)
      end

      # POST js
      def create
        alert = Alert.new(alert_params.merge!(by: user, patient: patient))
        authorize alert
        if alert.save
          render locals: { patient: patient, alert: alert }
        else
          render_form(alert, status: 422)
        end
      end

      # POST js
      # Idempotent
      def destroy
        alert = find_alert
        if alert.present?
          authorize alert
          alert.destroy
          render locals: { alert: alert }
        else
          skip_authorization
          head :ok
        end
      end

      private

      def find_alert
        Alert.find_by(id: params[:id])
      end

      def render_form(alert, status: 200)
        render :new,
               locals: { patient: patient, alert: alert },
               layout: false,
               status: status
      end

      def user
        @user ||= Renalware::Patients.cast_user(current_user)
      end

      def alert_params
        params.require(:patients_alert).permit(:notes, :urgent)
      end
    end
  end
end
