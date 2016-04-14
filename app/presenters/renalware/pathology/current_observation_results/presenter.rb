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
          [build_description(result), ObservationPresenter.new(result), format_date(result)]
        end
      end

      def build_description(result)
        description = ObservationDescription.new(
          code: result.description_code, name: result.description_name)
        ResultPresenter.new(description)
      end

      def format_date(result)
        date = I18n.l(result.observed_at.try(:to_date))
        DatePresenter.new(date)
      end

      class DatePresenter < SimpleDelegator
        def content
          to_s
        end
      end

      class ResultPresenter < SimpleDelegator
        def content
          name
        end
      end

      class ObservationPresenter < SimpleDelegator
        def content
          to_s
        end
      end
    end
  end
end
