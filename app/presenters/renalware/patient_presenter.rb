module Renalware
  class PatientPresenter < SimpleDelegator
    def to_s
      super(:long)
    end
  end
end