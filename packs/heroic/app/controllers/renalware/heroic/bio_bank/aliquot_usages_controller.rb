# frozen_string_literal: true

module Renalware
  module Heroic
    module BioBank
      class AliquotUsagesController < UsagesController
        def new
          usage = aliquot.build_usage(used_at: Time.zone.now)
          authorize usage
          render_new(usage)
        end

        def create
          usage = aliquot.build_usage(usage_params)
          authorize usage
          if usage.save_by(current_user)
            redirect_to bio_bank_sample_aliquots_path(aliquot.sample)
          else
            render_new(usage)
          end
        end

        def update
          usage = find_and_authorize_usage
          if usage.update_by(current_user, usage_params)
            redirect_to bio_bank_sample_aliquots_path(aliquot.sample)
          else
            render_edit(usage)
          end
        end

        def destroy
          find_and_authorize_usage.destroy
          redirect_to bio_bank_sample_aliquots_path(aliquot.sample)
        end

        private

        def aliquot
          @aliquot ||= Aliquot.find(params[:aliquot_id])
        end
        alias_method :usable, :aliquot

        def find_and_authorize_usage
          usable.usage.tap { |usage| authorize usage }
        end

        def patient
          aliquot.sample.patient
        end

        def render_new(usage)
          render :new, locals: {
            usage: usage,
            usable: usable,
            patient: patient,
            form_url: bio_bank_aliquot_usage_path(aliquot)
          }
        end

        def render_edit(usage)
          render :edit, locals: {
            usage: usage,
            usable: usable,
            patient: patient,
            form_url: bio_bank_aliquot_usage_path(aliquot)
          }
        end
      end
    end
  end
end
