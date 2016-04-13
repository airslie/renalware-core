require_dependency "renalware/pathology"

module Renalware
  module Pathology
    class ResultsPresenter
      def self.build(results, paginator)
        new(results, paginator)
      end

      attr_reader :paginator

      def initialize(results, paginator)
        @results = results
        @paginator = paginator
      end

      def present
        @presentation ||= present_results
      end

      def to_a
        present
      end

      private

      def present_results
        build_header + build_body
      end

      def build_header
        raise NotImplementedError
      end

      def build_body
        raise NotImplementedError
      end
    end
  end
end
