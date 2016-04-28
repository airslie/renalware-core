require "rails_helper"

module Renalware
  module Pathology
    RSpec.describe ObservationDateRange do
      describe ".build" do
        it "returns a range" do
          date_series =  [
            date("2013-01-01"),
            date("2014-01-01"),
            date("2015-01-01"),
            date("2016-01-01")
          ]
          expected_range = Range.new(date("2013-01-01"), date("2016-01-02"))

          expect(ObservationDateRange.build(date_series)).to eq(expected_range)
        end

        def date(string)
          Time.parse(string).to_date
        end
      end
    end
  end
end
