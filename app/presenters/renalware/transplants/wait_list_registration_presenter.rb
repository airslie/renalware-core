module Renalware
  module Transplants
    class WaitListRegistrationPresenter < SimpleDelegator
      delegate :tissue_typing, to: :document
      delegate :status, :updated_at, to: :tissue_typing, prefix: true

      def tissue_typing_summary
        return unless tissue_typing_status
        "#{tissue_typing_status} (#{I18n.l(tissue_typing_updated_at)})"
      end
    end
  end
end
