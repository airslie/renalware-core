# frozen_string_literal: true


module Renalware
  module Heroic
    module BioBank
      class UsagesController < Renalware::BaseController
        def edit
          render_edit(find_and_authorize_usage)
        end

        private

        def usage_params
          params.require(:usage).permit(:notes, :study_name, :used_at)
        end

        def render_new(usage)
          render :new, locals: { usage: usage, usable: usable, patient: patient }
        end

        def render_edit(usage)
          render :edit, locals: { usage: usage, usable: usable, patient: patient }
        end
      end
    end
  end
end
