module Renalware
  module Modalities
    class ChangeType
      OPTIONS = {
        "Other" => "other",
        "HaemodialysisToPD" => "Haemodialysis To PD",
        "PDToHaemodialysis" => "PD To Haemodialysis"
      }

      def self.to_a
        OPTIONS.invert.to_a
      end
    end
  end
end