require_dependency "renalware"

module Renalware
  module Transplants
    class ConsentPresenter < SimpleDelegator
      # This method smells of :reek:NilCheck
      def to_s
        [I18n.l(consented_on), value&.text].compact.join(" ")
      end
    end
  end
end
