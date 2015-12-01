module Renalware
  class PatientPresenter < SimpleDelegator
    def to_s
      super(:reversed_full_name_with_nhs)
    end
  end
end