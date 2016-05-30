module Renalware
  module Patients
    class Language < ActiveRecord::Base
      validates :name, presence: true
    end
  end
end
