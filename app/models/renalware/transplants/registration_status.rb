require_dependency "renalware/transplants"

module Renalware
  module Transplants
    class RegistrationStatus < ActiveRecord::Base
      belongs_to :description, class_name: "RegistrationStatusDescription"

      scope :ordered, -> (direction=:desc) { order(started_on: direction) }

      validates :started_on, timeliness: { type: :date, allow_blank: false }
      validates :terminated_on, timeliness: { type: :date, allow_blank: true }

      def terminated?
        terminated_on.present?
      end

      def whodunnit_name
        if whodunnit.present?
          if user = User.find_by(id: whodunnit)
            user.name
          else
            "User #{whodunnit}"
          end
        else
          "System"
        end
      end

      def to_s
        description.to_s if description
      end
    end
  end
end