module Renalware
  # TODO: merge into medications controller when other dependencies
  # have been converted over to this controller
  #
  class PolymorphicMedicationsController < BaseController
    def index
      @treatable = treatable_class.find(treatable_id)

      authorize @treatable.patient

      @medications = @treatable.medications
    end

    def new
      @treatable = treatable_class.find(treatable_id)

      authorize @treatable.patient

      @medication = Medication.new(treatable: @treatable)
    end

    def create
      @treatable = treatable_class.find(params[:treatable_id])

      authorize patient = @treatable.patient

      @medication = @treatable.medications.create(
        medication_params.merge(patient: patient)
      )
    end

    def edit
      @medication = Medication.find(params[:id])
      @treatable = @medication.treatable

      authorize @treatable.patient
    end

    def update
      @medication = Medication.find(params[:id])
      @treatable = @medication.treatable

      authorize @treatable.patient

      @medication.update(medication_params)
    end

    def destroy
      @medication = Medication.find(params[:id])
      @treatable = @medication.treatable
      @medications = @treatable.medications

      authorize @treatable.patient

      @medication.destroy!
    end

    private

    def treatable_class
      @treatable_class ||= treatable_type.singularize.classify.constantize
    end

    def medication_params
      params.require(:medication).permit(
        :medicatable_id, :medicatable_type,
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
