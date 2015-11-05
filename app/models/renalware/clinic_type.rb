require_dependency "renalware"

module Renalware
  class ClinicType < ActiveRecord::Base
    validates :name, presence: true

    def to_s
      name
    end
  end
end
