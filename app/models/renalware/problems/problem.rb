require_dependency "renalware/problems"

module Renalware
  module Problems
    class Problem < ActiveRecord::Base
      include PatientScope

      acts_as_paranoid
      has_paper_trail class_name: "Renalware::Problems::ProblemVersion"

      belongs_to :patient

      validates :description, presence: true

      def full_description
        description
      end

      def formatted
        "#{full_description}, #{date}"
      end
    end
  end
end
