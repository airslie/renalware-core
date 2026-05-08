module Renalware
  class Configuration
    module Clinical
      def self.included(base)
        base.config_accessor(:clinical_duke_activity_status_index_url) do
          "https://www.mdcalc.com/calc/3910/duke-activity-status-index-dasi#next-steps"
        end

        base.config_accessor(:clinical_summary_max_events_to_display) { 10 }
        base.config_accessor(:clinical_summary_max_letters_to_display) { 10 }
      end
    end
  end
end
