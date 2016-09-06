require_dependency "renalware/medications"

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
        prescription.build_termination

        render_form(prescription, url: patient_prescriptions_path(@patient, @treatable))
      end

      def create
        @treatable = treatable_class.find(treatable_id)

        prescription = @patient.prescriptions.new(
          prescription_params.merge(treatable: @treatable)
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

        updated = RevisePrescription.new(prescription).call(prescription_params)

        if updated
          render_index
        else
          render_form(prescription, url: patient_prescription_path(@patient, prescription))
        end
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
        params
          .require(:medications_prescription)
          .permit(prescription_attributes)
          .deep_merge(by: current_user, termination_attributes: { by: current_user })
      end

      def prescription_attributes
        [
          :drug_id, :dose_amount, :dose_unit, :medication_route_id, :frequency,
          :route_description, :notes, :prescribed_on, :provider,
          { termination_attributes: :terminated_on }
        ]
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
        call_query(current_prescriptions_query)
      end

      def historical_prescriptions_query
        @historical_prescriptions_query ||=
          PrescriptionsQuery.new(
            relation: @treatable.prescriptions,
            search_params: params[:q]
          )
      end

      def call_query(query)
        query
          .call
          .with_created_by
          .with_medication_route
          .with_drugs
          .with_termination
      end

      def historical_prescriptions
        call_query(historical_prescriptions_query)
      end

      def find_drug_types
        Drugs::Type.all
      end
    end
  end
end
