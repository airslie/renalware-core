# frozen_string_literal: true

require "rails_helper"

module Renalware
  module Feeds
    module Files
      module Practices
        describe ImportJob do
          context "when importing fullfile.zip" do
            it "imports the 4 sample practices in the test fullfile.zip" do
              pending("PG COPY not avail on CircleCI docker setup yet") if ENV.key?("CI")
              file = create(
                :feed_file,
                :practices,
                location: file_fixture("practices/fullfile.zip")
              )
              create(:united_kingdom)

              expect{
                described_class.new.perform(file)
              }
              .to change{ Patients::Practice.count }.by(4)
              .and change{ Patients::Practice.deleted.count }.by(1)
            end
          end
        end
      end
    end
  end
end
