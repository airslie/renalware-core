module Renalware
  module Admin
    class HeidiUsageController < BaseController
      def show
        query = Heidi::UsageQuery.new(months: params[:months])
        authorize Heidi::Session, :index?

        render locals: {
          month_options: Heidi::UsageQuery.month_options(query.months),
          months: query.months,
          usage_rows: query.call
        }
      end
    end
  end
end
