require_dependency "renalware/clinical"

module Renalware
  module Clinical
    class AllergiesController < Clinical::BaseController

      def create
        result = CreateAllergy.new(patient, current_user).call(allergy_params) do |allergy|
          authorize allergy
        end
        if result.success?
          redirect_to :back, notice: t(".success", model_name: "allergy")
        else
          # we use client-side validation so will not get here
          raise NotImplementedError
        end
      end

      def destroy
        allergy = patient.allergies.find(params[:id])
        authorize allergy
        DeleteAllergy.new(allergy, current_user).call
        redirect_to :back, notice: t(".success_with_name", name: allergy.description)
      end

      private

      def allergy_params
        params.require(:clinical_allergy).permit([:description])
      end
    end
  end
end
