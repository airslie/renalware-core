# frozen_string_literal: true

module Renalware
  module Heroic
    module BioBank
      class AliquotsController < Renalware::BaseController
        def index
          aliquots = sample.aliquots.order(:id)
          authorize aliquots
          render locals: { aliquots: aliquots, sample: sample }
        end

        def new
          aliqout = sample.aliquots.new(by: current_user)
          authorize aliqout
          aliqout.save!
          redirect_to bio_bank_sample_aliquots_path(sample)
        end

        def destroy
          find_and_authorize_aliquot.destroy!
          redirect_to bio_bank_sample_aliquots_path(sample)
        end

        private

        def sample
          @sample ||= Sample.find(params[:sample_id])
        end

        def render_new(aliquot)
          render :new, locals: { aliquot: aliquot, sample: sample }
        end

        def find_and_authorize_aliquot
          sample.aliquots.find(params[:id]).tap { |aliquot| authorize aliquot }
        end
      end
    end
  end
end
