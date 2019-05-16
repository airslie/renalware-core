# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Feeds
    module Files
      module PrimaryCarePhysicians
        describe ImportJob do
          it "imports gps" do
            pending("PG COPY not avail on CircleCI docker setup yet") if ENV.key?("CI")
            file = create(
              :feed_file,
              :primary_care_physicians,
              location: file_fixture("primary_care_physicians/egpcur.zip")
            )

            expect {
              described_class.new.perform(file)
            }.to change { Patients::PrimaryCarePhysician.count }.by(2)
          end
        end
      end
    end
  end
end
