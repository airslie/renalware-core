require "rails_helper"

module Renalware
  module Patients
    describe MDMListQuery do
      describe "#call" do
        it "does seomting" do
          query_object = MDMListQuery.new(relation: Renalware::HD::Patient.all,
                                          modality: "HD",
                                          q: {})
          query_object.call
        end
      end
    end
  end
end
