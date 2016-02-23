module Renalware
  class MedicationsController < BaseController
    before_action :load_patient

    include MedicationsHelper

    def index
      @treatable = treatable_class.find(treatable_id)

      @q = medications_query
      @medications = @q.result
    end

    def new
      @treatable = treatable_class.find(treatable_id)

      @medication = Medication.new(treatable: @treatable)

      render "form", locals: { url: patient_medications_path(@patient, @treatable) }
    end

    def create
      @treatable = treatable_class.find(params[:treatable_id])

      @medication = @patient.medications.build(
        medication_params.merge(treatable: @treatable)
      )

      if @medication.save
        @medications = @treatable.medications
        render "index"
      else
        render "form", locals: { url: patient_medications_path(@patient, @treatable) }
      end
    end

    def edit
      @medication = Medication.find(params[:id])
      @treatable = @medication.treatable

      render "form", locals: { url: patient_medication_path(@patient, @medication) }
    end

    def update
      @medication = Medication.find(params[:id])
      @treatable = @medication.treatable

      if @medication.update(medication_params)
        @medications = @treatable.medications
        render "index"
      else
        render "form", locals: { url: patient_medication_path(@patient, @medication) }
      end
    end

    def destroy
      @medication = Medication.find(params[:id])
      @treatable = @medication.treatable
      @medications = @treatable.medications

      @medication.destroy!

      render "index"
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

    def medications_query
      @treatable.medications.search(params[:q]).tap do | query|
        query.sorts = ["start_date desc"] if query.sorts.empty?
      end
    end
  end
end
