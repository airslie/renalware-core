module Renalware
  module Patients
    #
    # Synchronises practices and GPs from the NHS ODS Data Search and Export service.
    #
    class SyncODSJob < ApplicationJob
      retry_on ODS::DSE::DownloadError,
               ODS::DSE::ValidationError,
               wait: :polynomially_longer,
               attempts: 3

      def perform(dry_run: false)
        ODS::DSE::Synchroniser.new(dry_run:).call
      end
    end
  end
end
