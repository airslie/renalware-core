# frozen_string_literal: true

require_dependency "renalware/letters"

module Renalware
  module HD
    module SessionForms
      BatchPrintJob = Struct.new(:batch_id, :user_id) do
        include UsingTempFolder

        # Returns the name of a temp file containing the pdf data
        def perform
          in_a_temporary_folder do |dir|
            Dir.chdir(dir) do
              batch = Batch.find(batch_id)
              user = User.find(user_id)
              BatchCompilePdfs.call(batch, user)
            end
          end
        end

        def max_attempts
          1
        end

        def queue_name
          "hd_session_forms"
        end

        def priority
          0 # high
        end

        def destroy_failed_jobs?
          true
        end
      end
    end
  end
end
