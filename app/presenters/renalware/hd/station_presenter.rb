module Renalware
  module HD
    class StationPresenter < SimpleDelegator
      def name
        super.blank? ? "Unnamed Station" : super
      end
    end
  end
end
