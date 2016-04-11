require_dependency "renalware"

module Renalware
  module Clinics
    class Clinic < ActiveRecord::Base
      validates :name, presence: true

      def to_s
        name
      end
    end
  end 
end
