module Renalware
  class MedicationsController < BaseController
    before_action :load_patient

    include MedicationsHelper

    def index
      @treatable = treatable_class.find(treatable_id)

      render locals: {
        query: medications_query,
        patient: @patient,
        treatable: @treatable,
        medications: medications_query.result
      }
    end

    def new
      @treatable = treatable_class.find(treatable_id)

      medication = Medication.new(treatable: @treatable)

      render "form", locals: {
        patient: @patient,
        treatable: @treatable,
        medication: medication,
        url: patient_medications_path(@patient, @treatable)
      }
    end

    def create
      @treatable = treatable_class.find(treatable_id)

      medication = @patient.medications.build(
        medication_params.merge(treatable: @treatable)
      )

      if medication.save
        render "index", locals: {
          query: @q,
          patient: @patient,
          treatable: @treatable,
          medications: medications_query.result
        }
      else
        render "form", locals: {
          patient: @patient,
          treatable: @treatable,
          medication: medication,
          url: patient_medications_path(@patient, treatable)
        }
      end
    end

    def edit
      medication = Medication.find(params[:id])
      @treatable = medication.treatable

      render "form", locals: {
        patient: @patient,
        treatable: @treatable,
        medication: medication,
        url: patient_medication_path(@patient, medication)
      }
    end

    def update
      medication = Medication.find(params[:id])
      @treatable = medication.treatable

      if medication.update(medication_params)
        render "index", locals: {
          query: @q,
          patient: @patient,
          treatable: @treatable,
          medications: medications_query.result
        }
      else
        render "form", locals: {
          patient: @patient,
          treatable: @treatable,
          medication: medication,
          url: patient_medication_path(@patient, medication)
        }
      end
    end

    def destroy
      medication = Medication.find(params[:id])
      medication.destroy!

      @treatable = medication.treatable
      render "index", locals: {
        query: @q,
        patient: @patient,
        treatable: @treatable,
        medications: medications_query.result
      }
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
