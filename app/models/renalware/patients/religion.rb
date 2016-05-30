module Renalware
  module Patients
    class Religion < ActiveRecord::Base
      validates :name, presence: true
    end
  end
end
