require "collection_presenter"
require_dependency "renalware/clinical"

module Renalware
  module Clinical
    class BodyCompositionsController < Clinical::BaseController
      before_action :load_patient

      def index
        query = PatientBodyCompositionsQuery.new(patient: patient, search_params: params[:q])
        body_compositions = query.call.page(params[:page]).per(15)

        render locals: {
          search: query.search,
          body_compositions: CollectionPresenter.new(body_compositions, BodyCompositionPresenter),
          patient: patient
        }
      end

      def show
        body_composition = find_body_composition
        @body_composition = BodyCompositionPresenter.new(body_composition)
        render locals: { patient: patient, body_composition: body_composition }
      end

      def new
        save_path_to_return_to
        body_composition = BodyComposition.new(
          patient: patient,
          assessor: current_user,
          assessed_on: Time.zone.today
        )
        render_new(body_composition)
      end

      def create
        body_composition = BodyComposition.new(patient: patient)
        body_composition.attributes = body_composition_params

        if body_composition.save
          redirect_to return_url, notice: t(".success", model_name: "dry weight")
          session.delete(:return_to)
        else
          flash[:error] = t(".failed", model_name: "dry weight")
          render_new(body_composition)
        end
      end

      def edit
        body_composition = find_body_composition
        @body_composition = body_composition
        render locals: { patient: patient, body_composition: body_composition }
      end

      def update
        body_composition = find_body_composition
        authorize body_composition
        if body_composition.update(body_composition_params)
          redirect_to patient_clinical_profile_path(patient),
            notice: success_msg_for("body_composition")
        else
          render :edit, locals: { patient: patient, body_composition: body_composition }
        end
      end

      protected

      def save_path_to_return_to
        return unless request.format == :html
        session[:return_to] ||= request.referer
      end

      def return_url
        @return_url ||= begin
          path = session[:return_to]
          path = nil if path == new_patient_clinical_body_composition_path(patient)
          path || patient_clinical_profile_path(patient)
        end
      end
      helper_method :return_url

      def render_new(body_composition)
        render :new, locals: {
          body_composition: body_composition,
          patient: patient
        }
      end

      def body_composition_params
        params
          .require(:clinical_body_composition)
          .permit(attributes)
          .merge(by: current_user)
      end

      def find_body_composition
        Clinical::BodyComposition.for_patient(patient).find(params[:id])
      end

      def attributes
        [
          :assessed_on, :overhydration, :volume_of_distribution, :total_body_water,
          :extracellular_water, :intracellular_water, :lean_tissue_index,
          :fat_tissue_index, :lean_tissue_mass, :fat_tissue_mass, :adipose_tissue_mass,
          :body_cell_mass, :quality_of_reading, :assessor_id, :notes
        ]
      end
    end
  end
end
