# frozen_string_literal: true

module Renalware
  module Heroic
    module BioBank
      class SamplesController < Renalware::BaseController
        def index
          samples = Sample.includes(:sample_type).where(patient: patient).all
          authorize(samples)
          render locals: { patient: patient, samples: samples }
        end

        def new
          sample = Sample.new(patient: patient, received_at: Time.zone.now)
          authorize sample
          render_new(sample)
        end

        def create
          sample = Sample.new(sample_params.merge(patient: patient))
          authorize sample
          if sample.save_by(current_user)
            redirect_to bio_bank_patient_samples_path(patient)
          else
            render_new(sample)
          end
        end

        def edit
          sample = find_and_authorize_sample
          render_edit(sample)
        end

        def update
          sample = find_and_authorize_sample
          if sample.update_by(current_user, sample_params)
            redirect_to bio_bank_patient_samples_path(patient)
          else
            reder_edit(sample)
          end
        end

        def destroy
          sample = find_and_authorize_sample
          isbt = sample.isbt
          aliquot_count = sample.aliquots.size
          sample.destroy!
          redirect_to(
            bio_bank_patient_samples_path(patient),
            notice: "Sample with ISBT #{isbt} and its #{aliquot_count} aliquots deleted"
          )
        end

        private

        def render_new(sample)
          render :new, locals: { patient: patient, sample: sample }
        end

        def render_edit(sample)
          render :edit, locals: { patient: patient, sample: sample }
        end

        def find_and_authorize_sample
          Sample.find_by!(patient: patient, id: params[:id]).tap do |sample|
            authorize sample
          end
        end

        def sample_params
          params
            .require(:sample)
            .permit(
              :study_visit_number, :sample_type_id, :collected_at,
              :received_at, :processed_at, :storage_location, :notes
            )
        end
      end
    end
  end
end
