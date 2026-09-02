module Renalware
  module Heidi
    class SessionsQuery
      def initialize(params = {})
        @params = params
        @params[:s] ||= "created_at desc"
      end

      def call
        search
          .result
          .includes(:patient, :user, :clinic_visit)
      end

      def search
        @search ||= Session.ransack(params)
      end

      private

      attr_reader :params
    end
  end
end
