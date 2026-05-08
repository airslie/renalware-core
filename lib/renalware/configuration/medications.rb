module Renalware
  class Configuration
    module Medications
      def self.included(base)
        base.config_accessor(:medication_delivery_purchase_order_prefix) { "R" }

        base.config_accessor(:medication_homecare_pdf_forms) do
          # esa: { provider: :generic, version: 1 },
          {
            immunosuppressant: { provider: :generic, version: 1 }
          }
        end

        base.config_accessor(:medication_review_max_age_in_months) { 24 }
      end
    end
  end
end
