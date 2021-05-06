# frozen_string_literal: true

require_dependency "renalware/medications"

module Renalware
  module Medications
    class Review < Events::Event
      belongs_to :patient

      def self.latest
        order(date_time: :desc).first
      end

      def partial_for(partial_type)
        File.join("renalware/medications/reviews", partial_type)
      end
    end
  end
end
