require_dependency "renalware/letters"
require "collection_presenter"

module Renalware
  module Letters
    class LetterPresenter < DumbDelegator
      def main_recipient
        RecipientPresenter.new(super)
      end

      def cc_recipients
        ::CollectionPresenter.new(super, RecipientPresenter)
      end

      def recipients
        ::CollectionPresenter.new(super, RecipientPresenter)
      end
    end
  end
end
