require_dependency "renalware/accesses"

module Renalware
  module Accesses
    class Site < ActiveRecord::Base
      validates :code, presence: true
      validates :name, presence: true

      scope :ordered, -> { order(:name) }

      def to_s
        name
      end
    end
  end
end
