module Renalware
  module Modalities
    class ChangeType
      OPTIONS = {
        "Other" => "other",
        "Haemodialysis To PD" => "haemodialysis_to_pd",
        "PD To Haemodialysis" => "pd_to_haemodialysis"
      }

      def self.to_a
        OPTIONS.to_a
      end
    end
  end
end