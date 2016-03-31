require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class DatePresenter < SimpleDelegator
      def to_s
        I18n.l(self)
      end

      def html_class
        "date"
      end
    end
  end
end
