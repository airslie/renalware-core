module Renalware
  module UKRDC
    class PathologyObservationPresenter < SimpleDelegator
      # The PrePost element in ResultItem
      # For HD patients, all bloods are PRE except the post dialysis urea,
      # For non-HD patients, all the tests are NA
      def pre_post(patient_is_on_hd)
        if patient_is_on_hd
          description_code.casecmp("UREP") >= 0 ? "POST" : "PRE"
        else
          "NA"
        end
      end
    end
  end
end
