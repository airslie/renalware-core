require_dependency "renalware/pd"

module Renalware
  module PD
    class System < ActiveRecord::Base
      acts_as_paranoid

      validates :name, presence: true
      validates :pd_type, presence: true

      scope :for_apd, -> { where(apd_type: "APD") }
      scope :for_capd, -> { where(apd_type: "CAPD") }
    end
  end
end
