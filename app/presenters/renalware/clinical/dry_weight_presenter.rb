# frozen_string_literal: true

module Renalware
  module Clinical
    class DryWeightPresenter < DumbDelegator
      def assessed_on
        ::I18n.l(super)
      end

      def to_s
        "#{weight} (#{assessed_on})"
      end
    end
  end
end
