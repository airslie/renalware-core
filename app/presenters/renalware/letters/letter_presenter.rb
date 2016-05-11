require_dependency "renalware/letters"
require "collection_presenter"

module Renalware
  module Letters
    class LetterPresenter < DumbDelegator
      def main_recipient
        RecipientPresenterFactory.new(super)
      end

      def cc_recipients
        @cc_recipients_with_counterparts ||= begin
          assign_counterpart_ccs
          ::CollectionPresenter.new(super, RecipientPresenterFactory)
        end
      end
    end
  end
end
