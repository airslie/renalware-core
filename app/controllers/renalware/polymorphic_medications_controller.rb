module Renalware
  # TODO: merge into medications controller when other dependencies
  # have been converted over to this controller
  #
  class PolymorphicMedicationsController < BaseController
    before_action :load_patient

    def index
      @treatable = treatable_class.find(treatable_id)

      @medications = @treatable.medications
    end

    def new
      @treatable = treatable_class.find(treatable_id)

      @medication = Medication.new(treatable: @treatable)
    end

    def create
      @treatable = treatable_class.find(params[:treatable_id])

      @medication = @patient.medications.create(
        medication_params.merge(treatable: @treatable)
      )
    end

    def edit
      @medication = Medication.find(params[:id])
      @treatable = @medication.treatable
    end

    def update
      @medication = Medication.find(params[:id])
      @treatable = @medication.treatable

      @medication.update(medication_params)
    end

    def destroy
      @medication = Medication.find(params[:id])
      @treatable = @medication.treatable
      @medications = @treatable.medications

      @medication.destroy!
    end

    private

    def treatable_class
      @treatable_class ||= treatable_type.singularize.classify.constantize
    end

    def medication_params
      params.require(:medication).permit(
        :drug_id,
        :dose, :medication_route_id, :frequency, :notes,
        :start_date, :end_date, :provider
      )
    end

    def treatable_type
      params.fetch(:treatable_type)
    end

    def treatable_id
      params.fetch(:treatable_id)
    end
  end
end
