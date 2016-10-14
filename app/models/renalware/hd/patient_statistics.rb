require_dependency "renalware/hd"

module Renalware
  module HD
    class PatientStatistics < ActiveRecord::Base
      include PatientScope

      belongs_to :patient

      validates :patient, presence: true
      validates :period_starts_at, presence: true
    end
  end
end
