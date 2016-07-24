module Renalware
  module Medications
    class PrescriptionsController < BaseController
      include PrescriptionsHelper
      include PresenterHelper

      before_action :load_patient

      def index
        @treatable = treatable_class.find(treatable_id)

        render_index
      end

      def new
        @treatable = treatable_class.find(treatable_id)
        prescription = Prescription.new(treatable: @treatable)

        render_form(prescription, url: patient_prescriptions_path(@patient, @treatable))
      end

      def create
        @treatable = treatable_class.find(treatable_id)

        prescription = @patient.prescriptions.new(
          prescription_params.merge(by: current_user, treatable: @treatable)
        )

        if prescription.save
          render_index
        else
          render_form(prescription, url: patient_prescriptions_path(@patient, @treatable))
        end
      end

      def edit
        prescription = @patient.prescriptions.find(params[:id])
        @treatable = prescription.treatable

        render_form(prescription, url: patient_prescription_path(@patient, prescription))
      end

      def update
        prescription = @patient.prescriptions.find(params[:id])
        @treatable = prescription.treatable

        updated = UpdatePrescription.new(
          prescription,
          prescription_params.merge(by: current_user)
        ).call

        if updated
          render_index
        else
          render_form(prescription, url: patient_prescription_path(@patient, prescription))
        end
      end

      def destroy
        prescription = @patient.prescriptions.find(params[:id])
        @treatable = prescription.treatable

        prescription.terminate(by: current_user).save!

        render_index
      end

      private

      def render_index
        render "index", locals: {
          patient: @patient,
          treatable: present(@treatable, TreatablePresenter),
          current_search: current_prescriptions_query.search,
          current_prescriptions: present(current_prescriptions, PrescriptionPresenter),
          historical_prescriptions_search: historical_prescriptions_query.search,
          historical_prescriptions: present(historical_prescriptions, PrescriptionPresenter),
          drug_types: find_drug_types
        }
      end

      def render_form(prescription, url:)
        render "form", locals: {
          patient: @patient,
          treatable: @treatable,
          prescription: prescription,
          provider_codes: present(Provider.codes, ProviderCodePresenter),
          medication_routes: present(MedicationRoute.all, RouteFormPresenter),
          url: url
        }
      end

      def treatable_class
        @treatable_class ||= treatable_type.singularize.classify.constantize
      end

      def prescription_params
        params.require(:medications_prescription).permit(
          :drug_id, :dose, :medication_route_id, :frequency, :route_description,
          :notes, :prescribed_on, :terminated_on, :provider
        )
      end

      def treatable_type
        params.fetch(:treatable_type)
      end

      def treatable_id
        params.fetch(:treatable_id)
      end

      def current_prescriptions_query
        @current_prescriptions_query ||=
          PrescriptionsQuery.new(
            relation: @treatable.prescriptions.current,
            search_params: params[:q]
          )
      end

      def current_prescriptions
        current_prescriptions_query.call.includes(:drug)
      end

      def historical_prescriptions_query
        @historical_prescriptions_query ||=
          PrescriptionsQuery.new(
            relation: @treatable.prescriptions,
            search_params: params[:q]
          )
      end

      def historical_prescriptions
        historical_prescriptions_query.call.includes(:drug)
      end

      def find_drug_types
        Drugs::Type.all
      end
    end
  end
end
