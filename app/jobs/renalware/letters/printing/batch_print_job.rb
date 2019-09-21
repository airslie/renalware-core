# frozen_string_literal: true

require_dependency "renalware/letters"
require "attr_extras"

module Renalware
  module Letters
    module Printing
      class BatchPrintJob < ApplicationJob
        include UsingTempFolder

        # Returns the name of a temp file containing the pdf data
        def perform(batch, user)
          in_a_temporary_folder do |dir|
            Dir.chdir(dir) do
              BatchCompilePdfs.call(batch, user)
            end
          end
        end

        def max_attempts
          2
        end
      end
    end
  end
end
