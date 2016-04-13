require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class CurrentObservationResults::Presenter
      attr_reader :view_model

      def present(results)
        @view_model = [build_header] + build_body(results)
      end

      private

      def build_header
        ["description", "result", "date"]
      end

      def build_body(results)
        results.map do |result|
          [build_description(result), result, format_date(result)]
        end
      end

      def build_description(result)
        ObservationDescription.new(code: result.description_code, name: result.description_name)
      end

      def format_date(result)
        I18n.l(result.observed_at.to_date)
      end
    end
  end
end
