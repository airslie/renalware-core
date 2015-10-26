module Renalware
  class DrugDrugTypesController < BaseController

    #TODO: Refactor
    def index
      @drug = Drug.find(params[:drug_id])
      @drug_drug_types = @drug.drug_drug_types

      @assign_drug_types = DrugDrugType.new(:drug => @drug)
      authorize @assign_drug_types
    end

    def create
      @drug_drug_type = DrugDrugType.create!(allowed_params)
      authorize @drug_drug_type

      redirect_to drug_drug_drug_types_path
    end

    def destroy
      @drug_drug_type = DrugDrugType.find(params[:id])
      authorize @drug_drug_type

      @drug_drug_type.destroy!
    end

    private

    def allowed_params
      params.require(:drug_drug_type).permit(:drug_id, :drug_type_id)
    end
  end
end
